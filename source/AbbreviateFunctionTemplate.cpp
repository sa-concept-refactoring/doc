//===-- AbbreviateFunctionTemplate.cpp ---------------------------*- C++-*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
#include "FindTarget.h"
#include "SourceCode.h"
#include "XRefs.h"
#include "refactor/Tweak.h"
#include "support/Logger.h"
#include "clang/AST/ASTContext.h"
#include "clang/AST/ExprConcepts.h"
#include "clang/Tooling/Core/Replacement.h"
#include "llvm/ADT/StringRef.h"
#include "llvm/Support/Casting.h"
#include "llvm/Support/Error.h"
#include <numeric>

namespace clang {
namespace clangd {
namespace {
/// Converts a function template to its abbreviated form using auto parameters.
/// Before:
///     template <std::integral T>
///     auto foo(T param) { }
///          ^^^^^^^^^^^
/// After:
///     auto foo(std::integral auto param) { }
class AbbreviateFunctionTemplate : public Tweak {
public:
  const char *id() const final;

  auto prepare(const Selection &Inputs) -> bool override;
  auto apply(const Selection &Inputs) -> Expected<Effect> override;

  auto title() const -> std::string override {
    return "Abbreviate function template";
  }

  auto kind() const -> llvm::StringLiteral override {
    return CodeAction::REFACTOR_KIND;
  }

private:
  const char *AutoKeywordSpelling = getKeywordSpelling(tok::kw_auto);
  const FunctionTemplateDecl *FunctionTemplateDeclaration;

  std::vector<const TypeConstraint *> TypeConstraints;
  std::vector<unsigned int> ParameterIndices;
  std::vector<std::vector<tok::TokenKind>> Qualifiers;

  auto traverseParameters(size_t NumberOfTemplateParameters) -> bool;

  auto generateFunctionParameterReplacement(unsigned int, ASTContext &Context)
      -> llvm::Expected<tooling::Replacement>;

  auto generateTemplateDeclarationReplacement(ASTContext &Context)
      -> llvm::Expected<tooling::Replacement>;

  static auto deconstructType(QualType Type)
      -> std::tuple<QualType, std::vector<tok::TokenKind>>;

  template <typename T>
  static auto findDeclaration(const SelectionTree::Node &Root) -> const T * {
    return findNode<T, Decl>(Root);
  }

  template <typename T, typename NodeKind>
  static auto findNode(const SelectionTree::Node &Root) -> const T *;
};

REGISTER_TWEAK(AbbreviateFunctionTemplate)

bool AbbreviateFunctionTemplate::prepare(const Selection &Inputs) {
  const auto *Root = Inputs.ASTSelection.commonAncestor();
  if (!Root)
    return false;

  FunctionTemplateDeclaration = findDeclaration<FunctionTemplateDecl>(*Root);
  if (!FunctionTemplateDeclaration)
    return false;

  auto *TemplateParameters =
      FunctionTemplateDeclaration->getTemplateParameters();

  auto NumberOfTemplateParameters = TemplateParameters->size();
  TypeConstraints.reserve(NumberOfTemplateParameters);
  ParameterIndices.reserve(NumberOfTemplateParameters);
  Qualifiers.reserve(NumberOfTemplateParameters);

  // Check how many times each template parameter is referenced.
  // Depending on the number of references it can be checked
  // if the refactoring is possible:
  // - exactly one: The template parameter was declared but never used, which
  //                means we know for sure it doesn't appear as a parameter.
  // - exactly two: The template parameter was used exactly once, either as a
  //                parameter or somewhere else. This is the case we are
  //                interested in.
  // - more than two: The template parameter was either used for multiple
  //                  parameters or somewhere else in the function.
  for (auto *TemplateParameter : *TemplateParameters) {
    auto *TemplateParameterDeclaration =
        dyn_cast_or_null<TemplateTypeParmDecl>(TemplateParameter);
    if (!TemplateParameterDeclaration)
      return false;

    TypeConstraints.push_back(
        TemplateParameterDeclaration->getTypeConstraint());

    auto TemplateParameterPosition = sourceLocToPosition(
        Inputs.AST->getSourceManager(), TemplateParameter->getEndLoc());
    auto ReferencesResult =
        findReferences(*Inputs.AST, TemplateParameterPosition, 3, Inputs.Index);

    if (ReferencesResult.References.size() != 2)
      return false;
  }

  return traverseParameters(NumberOfTemplateParameters);
}

auto AbbreviateFunctionTemplate::apply(const Selection &Inputs)
    -> Expected<Tweak::Effect> {
  auto &Context = Inputs.AST->getASTContext();

  tooling::Replacements Replacements{};

  // Replace parameter type declaration
  auto TemplateParameterCount = ParameterIndices.size();
  for (auto TemplateParameterIndex = 0u;
       TemplateParameterIndex < TemplateParameterCount;
       TemplateParameterIndex++) {
    auto FunctionParameterReplacement =
        generateFunctionParameterReplacement(TemplateParameterIndex, Context);

    if (auto Err = FunctionParameterReplacement.takeError())
      return Err;

    if (auto Err = Replacements.add(*FunctionParameterReplacement))
      return Err;
  }

  // Remove template declaration
  auto TemplateDeclarationReplacement =
      generateTemplateDeclarationReplacement(Context);

  if (auto Err = TemplateDeclarationReplacement.takeError())
    return Err;

  if (auto Err = Replacements.add(*TemplateDeclarationReplacement))
    return Err;

  return Effect::mainFileEdit(Context.getSourceManager(), Replacements);
}

auto AbbreviateFunctionTemplate::traverseParameters(
    size_t NumberOfTemplateParameters) -> bool {
  auto CurrentTemplateParameterBeingChecked = 0u;
  auto Parameters = FunctionTemplateDeclaration->getAsFunction()->parameters();

  for (auto ParameterIndex = 0u; ParameterIndex < Parameters.size();
       ParameterIndex++) {
    auto [RawType, QualifiersForType] =
        deconstructType(Parameters[ParameterIndex]->getType());

    if (!RawType->isTemplateTypeParmType())
      continue;

    auto TemplateParameterIndex =
        dyn_cast<TemplateTypeParmType>(RawType)->getIndex();

    if (TemplateParameterIndex != CurrentTemplateParameterBeingChecked)
      return false;

    Qualifiers.push_back(QualifiersForType);
    ParameterIndices.push_back(ParameterIndex);
    CurrentTemplateParameterBeingChecked += 1;
  }

  // All defined template parameters need to be used as function parameters
  return CurrentTemplateParameterBeingChecked == NumberOfTemplateParameters;
}

template <typename T, typename NodeKind>
auto AbbreviateFunctionTemplate::findNode(const SelectionTree::Node &Root)
    -> const T * {
  for (const auto *Node = &Root; Node; Node = Node->Parent) {
    if (const T *Result = dyn_cast_or_null<T>(Node->ASTNode.get<NodeKind>()))
      return Result;
  }

  return nullptr;
}

auto AbbreviateFunctionTemplate::generateFunctionParameterReplacement(
    unsigned int TemplateParameterIndex, ASTContext &Context)
    -> llvm::Expected<tooling::Replacement> {
  auto &SourceManager = Context.getSourceManager();

  auto FunctionParameterIndex = ParameterIndices[TemplateParameterIndex];
  auto *TypeConstraint = TypeConstraints[TemplateParameterIndex];

  const auto *Function = FunctionTemplateDeclaration->getAsFunction();
  auto *Parameter = Function->getParamDecl(FunctionParameterIndex);
  auto ParameterName = Parameter->getDeclName().getAsString();

  std::vector<std::string> ParameterTokens{};

  if (TypeConstraint != nullptr) {
    auto *ConceptReference = TypeConstraint->getConceptReference();
    auto *NamedConcept = ConceptReference->getNamedConcept();

    ParameterTokens.push_back(NamedConcept->getQualifiedNameAsString());

    if (const auto *TemplateArgs = TypeConstraint->getTemplateArgsAsWritten()) {
      auto TemplateArgsRange = SourceRange(TemplateArgs->getLAngleLoc(),
                                           TemplateArgs->getRAngleLoc());
      auto TemplateArgsSource = toSourceCode(SourceManager, TemplateArgsRange);
      ParameterTokens.push_back(TemplateArgsSource.str() + '>');
    }
  }

  ParameterTokens.push_back(AutoKeywordSpelling);

  for (const auto &Qualifier : Qualifiers[TemplateParameterIndex]) {
    const char *Spelling = getKeywordSpelling(Qualifier);

    if (!Spelling)
      Spelling = getPunctuatorSpelling(Qualifier);

    if (Spelling)
      ParameterTokens.push_back(Spelling);
  }

  ParameterTokens.push_back(ParameterName);

  auto FunctionTypeReplacementText = std::accumulate(
      ParameterTokens.begin(), ParameterTokens.end(), std::string{},
      [](auto Result, auto Token) { return Result + " " + Token; });

  auto FunctionParameterRange = toHalfOpenFileRange(
      SourceManager, Context.getLangOpts(), Parameter->getSourceRange());

  if (!FunctionParameterRange)
    return error("Could not obtain range of the template parameter. Macros?");

  return tooling::Replacement(
      SourceManager, CharSourceRange::getCharRange(*FunctionParameterRange),
      FunctionTypeReplacementText);
}

auto AbbreviateFunctionTemplate::generateTemplateDeclarationReplacement(
    ASTContext &Context) -> llvm::Expected<tooling::Replacement> {
  auto &SourceManager = Context.getSourceManager();
  auto *TemplateParameters =
      FunctionTemplateDeclaration->getTemplateParameters();

  auto TemplateDeclarationRange =
      toHalfOpenFileRange(SourceManager, Context.getLangOpts(),
                          TemplateParameters->getSourceRange());

  if (!TemplateDeclarationRange)
    return error("Could not obtain range of the template parameter. Macros?");

  auto CharRange = CharSourceRange::getCharRange(*TemplateDeclarationRange);
  return tooling::Replacement(SourceManager, CharRange, "");
}

auto AbbreviateFunctionTemplate::deconstructType(QualType Type)
    -> std::tuple<QualType, std::vector<tok::TokenKind>> {
  std::vector<tok::TokenKind> Qualifiers{};

  if (isa<PackExpansionType>(Type))
    Qualifiers.push_back(tok::ellipsis);

  Type = Type.getNonPackExpansionType();

  if (Type->isRValueReferenceType()) {
    Qualifiers.push_back(tok::ampamp);
    Type = Type.getNonReferenceType();
  }

  if (Type->isLValueReferenceType()) {
    Qualifiers.push_back(tok::amp);
    Type = Type.getNonReferenceType();
  }

  if (Type.isConstQualified()) {
    Qualifiers.push_back(tok::kw_const);
  }

  while (Type->isPointerType()) {
    Qualifiers.push_back(tok::star);
    Type = Type->getPointeeType();

    if (Type.isConstQualified()) {
      Qualifiers.push_back(tok::kw_const);
    }
  }

  std::reverse(Qualifiers.begin(), Qualifiers.end());

  return {Type, Qualifiers};
}

} // namespace
} // namespace clangd
} // namespace clang
