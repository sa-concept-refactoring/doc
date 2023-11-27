//===-- AbbreviateFunctionTemplateTests.cpp ---------------------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "TweakTesting.h"
#include "gtest/gtest.h"

namespace clang {
namespace clangd {
namespace {

TWEAK_TEST(AbbreviateFunctionTemplate);

TEST_F(AbbreviateFunctionTemplateTest, Test) {
  Header = R"cpp(
      template <typename T>
      concept foo = true;

      template <typename T>
      concept bar = true;

      template <typename T, typename U>
      concept baz = true;

      template <typename T>
      class list;
  )cpp";

  ExtraArgs = {"-std=c++20"};

  EXPECT_EQ(apply("template <typename T> auto ^fun(T param) {}"),
            " auto fun( auto param) {}");
  EXPECT_EQ(apply("template <foo T> auto ^fun(T param) {}"),
            " auto fun( foo auto param) {}");
  EXPECT_EQ(apply("template <baz<int> T> auto ^fun(T param) {}"),
            " auto fun( baz <int> auto param) {}");
  EXPECT_EQ(apply("template <foo T, bar U> auto ^fun(T param1, U param2) {}"),
            " auto fun( foo auto param1,  bar auto param2) {}");
  EXPECT_EQ(apply("template <foo T> auto ^fun(T const ** param) {}"),
            " auto fun( foo auto const * * param) {}");
  EXPECT_EQ(apply("template <typename...ArgTypes> auto ^fun(ArgTypes...params) "
                  "-> void{}"),
            " auto fun( auto ... params) -> void{}");

  // TODO: Check if this causes issues due to the number of tests executed
  EXPECT_AVAILABLE(
      "t^e^m^p^l^a^t^e <^t^y^p^e^n^a^m^e ^T> a^u^t^o f^u^n^(^T p^a^r^a^m^) {}");
  EXPECT_AVAILABLE(
      "t^e^m^p^l^a^t^e <f^o^o ^T> a^u^t^o f^u^n^(^T p^a^r^a^m^) -> void {}");
  EXPECT_AVAILABLE("t^e^m^p^l^a^t^e <f^o^o ^T> a^u^t^o f^u^n^(^T const ** "
                   "p^a^r^a^m) -> void {}");
  EXPECT_AVAILABLE("t^e^m^p^l^a^t^e <t^y^p^e^n^a^m^e...ArgTypes> auto "
                   "f^u^n(^A^rgT^y^p^e^s...^p^a^r^a^m^s^) -> void{}");

  // No possible to click on `const`
  EXPECT_UNAVAILABLE(
      "template<typename T> auto fun(T c^o^n^s^t param) -> void {}");

  // The keyword `auto` can't be used within containers
  EXPECT_UNAVAILABLE(
      "template<typename T> auto f^u^n(list<T> param) -> void {}");

  // Template parameters need to be in the same order as function parameters
  EXPECT_UNAVAILABLE(
      "tem^plate<type^name ^T, typen^ame ^U> auto f^un(^U, ^T) -> void {}");

  // Template parameter type can't be used within the function body
  EXPECT_UNAVAILABLE(R"cpp(
    templ^ate<cl^ass T, in^t N>
    aut^o fu^n(T (&^a)[N], i^nt siz^e) -> v^oid {}
  )cpp");
}

} // namespace
} // namespace clangd
} // namespace clang
