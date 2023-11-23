#import "@preview/tablex:0.0.4": tablex

= Analysis <analysis>
// - Beschreibung des System-Kontexts
// - Funktionale und nicht-Funktionale Anforderungen
// - Use Cases/Scenarios/User Storys
// - Bestehende Infrastruktur
// - Abhängig vom Projekt: Risikoanalyse
// - Beschreibung (externen) existierenden Schnittstellen

This chapter documents the research of the Language Server Protocol (LSP), clangd, AST and the newly added construct in C++ 20, concepts.
To be able to contribute to the LLVM project @llvm_github it is important to understand the fundamentals explained in the following chapters.

== Language Server Protocol (LSP)

// TODO: show different editors with the same refactoring features (maybe with own implementation)

The Language Server Protocol, short LSP, is an open, JSON-RPC based protocol designed to communicate between code editors or integrated development environments (IDEs) and language servers, which provide language-specific features such as code completion, syntax highlighting, error checking and other services to enhance the capabilities of code editors.

@language_server_sequence shows an example for how a tool and a language server communicate during a routine editing session.

#figure(
  image("../images/language_server_sequence.png"),
  caption: [
    Diagram showing example communication between IDE and Language Server @lsp_overview
  ],
) <language_server_sequence>

The development tool is sending notifications and requests to the language server. 
The language server can then respond with the document URI and position of the symbol's definition inside the document for example.

The idea of the LSP as described by Microsoft:

#quote(attribution: [#cite(<lsp>, form: "author" )], block: true)[
The idea behind the Language Server Protocol (LSP) is to standardize the protocol for how such servers and development tools communicate. This way, a single Language Server can be re-used in multiple development tools, which in turn can support multiple languages with minimal effort.
]

By using a common protocol the same language server can be used by different editors which support the protocol.
This reduces the effort required to integrate language-specific features into various development environments,
allowing developers to have a more efficient and feature-rich coding experience, regardless of the programming language they are working with. 

Language servers are used within modern IDEs and code editors such as Visual Studio Code, Atom and Sublime Text.

/ Implementations: #[
The language servers implementing the LSP for C++ are shown in @cpp-implementation.
For this project the focus is set on the LLVM-Project which is explained in @lvvm-project.

#figure(
  tablex(
    columns: 4,
    auto-vlines: false,
    map-rows: (row, rows) => rows.map(r =>
      if r == none {
        r
      } else {
        (..r, fill: if row == 0 { luma(230) } else if row == 2  { rgb("#A8C8FE") } )
      }
    ),
    [*Language*], [*Maintainer*], [*Repository*], [*Implementation Language*],
    [C++],[Microsoft], [VS Code C++ extension], [C++],
    [C++/clang], [LLVM Project], [clangd], [C++],
    [C/C++/Objective-C], [Jacob Dufault, MaskRay, topisani], [cquery], [C++],
    [C/C++/Objective-C], [Jacob Dufault, MaskRay, topisani], [MaskRay], [C++]
  ),
  caption: [
    C++ language servers implementing the LSP @lsp_implementations
  ]
) <cpp-implementation>
]

=== LSP Features for Refactoring

To apply a refactoring using the LSP three steps are needed. 

+ Action Request
+ Execute Command
+ Apply Edit

The flow chart @lsp-sequence-diagram shows a quick overview of the requests used for refactoring features.
The details of the requests shown in the flow diagram are explained further in the following chapters.

#figure(
  image("../images/lsp_sequence_diagram.png", width: 80%),
  caption: [
    diagram showing Code Action and Code Action Resolve Request
  ],
) <lsp-sequence-diagram>

// TODO: add json examples
/ Code Action Request: #[
The code action request is sent from client to server to compute commands for a given text document and range.
To make the server useful in many clients, the command actions should be handled by the server and not by the client.

When a client requests possible code actions, the server computes which ones apply and sends them back in a JSON-encoded response.
@json_code_action_request_response shows an example answer to the Code Action Request.

#figure(
   [
    #set text(size: 0.8em)
    ```json
    [
      {
        "command": {
          "arguments": [
            {
              "file": "<path to class where request was sent>",
              "selection": {
                "end": {
                  "character": 21,
                  "line": 16
                },
                "start": {
                  "character": 21,
                  "line": 16
                }
              },
              "tweakID": "RefactorExample"
            }
          ],
          "command": "clangd.applyTweak",
          "title": "A Refactoring Example"
        },
        "kind": "refactor",
        "title": "A Refactoring Example"
      }
    ]
    ```
  ],
  caption: [
    Example answer to a code action request
  ],
) <json_code_action_request_response>
]

/ Executing a Command: #[
To apply a code change on the client side the client sends a `workspace/executeCommand` to the server.
The server can then create a WorkspaceEdit @lsp_workspace_edit structure and apply the changes to the workspace by sending a `workspace/applyEdit` @lsp_workspace_apply_edit command to the client.
]

// Kommentar Jeremy: Mer sett no sege wie jetz de command usgfüert wird. Bis jetz erkläre mer nur wiemer dezue chonnt.

== LLVM Project <lvvm-project>
The LLVM project @llvm_github is a collection of modular and reusable compiler and toolchain technologies.
One of the primary sub-projects is Clang which is a "LLVM native" C/C++/Objective-C compiler.

@llvm_illustration illustrates how the sub-projects are compiled.

#figure(
  image("../images/llvm_architecture.jpeg", width: 80%),
  caption: [
    Diagram showing architecture of LLVM @LLVM_compiler_architecture
  ],
) <llvm_illustration>

// TODO: explain how LSP works in general (client, server communication)
Code refactorings for C++ can be found within the clangd language server which is based on the clang compiler. @clangd

== The clangd Language Server

// TODO: wie gelangt language server an den code

Clangd is the language server which lives in the llvm-project repository @llvm_github under `clang-tools-extra/clangd`. 
It understands C++ code and adds smart features like code completion, compile errors and go-to-definition.

The C++ refactoring features can be found within the clangd under the `tweaks` folder.

== Coding Guidelines

As all big projects LLVM also has defined coding guidelines @llvm_coding_standards which should be followed.
The documentation is written really well and is easy to understand which makes it easy to follow.
A lot of guidelines are described but some things seem to be missing like the usage of trailing return types introduced with C++ 11 @function_declaration.

=== Code Formatter
To fulfill the formatting guidelines there is a formatter `clang-format` within the project to style the files according to the guidelines.
A check run on GitHub is ensuring that the format of the code is correct.
Only when the formatter has been run successfully a Pull-Request is allowed to be merged.

// TODO: add link

== Refactorings in clangd
Each refactoring option within clangd is implemented as a class, which inherits from a common `Tweak` ancestor.

=== Project Structure
The LLVM project is quite big and it took a while to figure out how it is structured.
For refactoring features classes can be created in the following directory: \
`llvm-project/clang-tools-extra/clangd/refactor/tweaks`.

=== Existing Refactorings
Looking at the refactoring features no feature could be found specific to concepts.
Some basic ones like symbol rename already work for them.
As concepts were introduced with C++20 it is quite new to the world of C++ and therefore not much of support exists yet.

For other scenarios multiple refactoring operations already exist (e.g. switching statements within an if).
Looking at existing refactoring code helped to understand how a refactoring is structured and implemented.

=== Testing <testing>
The LLVM project strictly adheres to a well-defined architecture for testing. 
To align with project guidelines @clangd_testing, automated unit tests must be authored prior to the acceptance of any code contributions. 
The name of these files is usually the name of the class itself and use the googletest framework @googletest_framework.

Unit tests are added to `llvm-project/clang-tools-extra/clangd/unittests`.

// TODO: explain test concept of clangd (for tweaks)

For testing tweaks three functions are typically used: `EXPECT_THAT`, `EXPECT_AVAILABLE`, and `EXPECT_UNAVAILABLE`.

/ `EXPECT_THAT` : #[
Executes the `apply` function and compares the result with the expected code.
]

/ `EXPECT_AVAILABLE` : #[
Check if the refactoring feature is available on certain cursor position within the code. 
The `prepare` function is executed.
]

/ `EXPECT_UNAVAILABLE` : #[
Check if the refactoring feature is unavailable on certain cursor position within the code. 
The `prepare` function is executed.
]

=== Code Actions

All refactoring features, so called "tweaks", reside in the `refactor/tweaks` directory, where they are registered through the linker. 
The return type of a tweak is always a Code Action, which represents a change that can be performed in code. @code_action
These compact plugins inherit the Tweak class which acts as a interface base.
// TODO: Das liesse sich schön visualisieren.
When presented with a selection, they can swiftly assess if they are applicable and, if necessary, create the edits, potentially at a slower pace.
These fundamental components constitute the foundation of the LSP code-actions flow.

Each tweak has its own class. The structure of this class is demonstrated in @tweak_structure.

#figure(
 [
    #set text(size: 0.8em)
    ```cpp
    namespace clang {
    namespace clangd {
    namespace {
    /// Feature description
    class RefactorExample : public Tweak {
    public:
      const char *id() const final;

      bool prepare(const Selection &Inputs) override;
      Expected<Effect> apply(const Selection &Inputs) override;
      std::string title() const override { return "A Refactoring Example"; }
      llvm::StringLiteral kind() const override {
        return CodeAction::REFACTOR_KIND;
      }
    };

    REGISTER_TWEAK(RefactorExample)

    bool RefactorExample::prepare(const Selection &Inputs) {
      // Check if refactoring is possible
    }

    Expected<Tweak::Effect> RefactorExample::apply(const Selection &Inputs) {
      // Refactoring code
    }

    } // namespace
    } // namespace clangd
    } // namespace clang
    ```
  ],
  caption: [
    Structure of tweak class
  ],
) <tweak_structure>

*```cpp bool prepare(const Selection &Inputs)```:* \
Within the `prepare` function a check is performed to see if a refactoring is possible on the selected area.
The function is returning a boolean indicating wether the action is available and should be shown to the user.
As this function should be fast only non-trivial work should be done within.
If the action requires non-trivial work it should be moved to the `apply` function.

// TODO check if this is correct
The function is triggered as soon as the "Refactoring" option within the Visual Studio Code is used.

*```cpp Expected<Tweak::Effect> apply(const Selection &Inputs)```:* \
Within the `apply` function the actual refactoring is taking place.
The function is triggered as soon as the refactoring tweak has ben selected.
// Kommentar Jeremy: Erkläre wieso, zb dass mer privati variable initialized.
It is expected that the `prepare` function has been called before to ensure that the second part of the action is working without problems.

It returns the effect which should be done on the client side.

== Abstract Syntax Tree (AST)

The Abstract Syntax Tree, short AST, is a syntax tree representing the abstract syntactic structure of a text.
It represents the syntactic structure of source code written in a programming language, capturing its grammar and organization in a tree-like form.
It provides a structured way to analyze and manipulate the code, making it easier for tools like code analyzers, code editors, and IDEs to understand and work with the code. @ast_twilio

Three steps are needed for a compiler to transform source code into compiled code.

+ *Lexical Analysis* - Convert code into set of tokens describing the different parts of the code. 
+ *Syntax Analysis* - Convert tokens into a tree that represents the actual structure of the code.
+ *Code Generation* - Generate code out of the abstract syntax tree.

@code_generation shows a visualization of the conversion steps.

#figure(
  image("../images/ast_generation.png"),
  caption: [
    diagram showing steps for code generation @ast_python
  ],
) <code_generation>

In Clangd, the "AST tree" refers to AST generated by the Clang compiler for a C++ source file.
Clangd uses this AST tree to provide features like code completion, code navigation, and code analysis in C++ development environments.

//TODO: maybe explain why it is better to transform ast instead of code itself

== Concepts

// TODO: describe concepts
