#import "@preview/tablex:0.0.4": tablex

#let cell(ok: false, body) = box(
  inset: 8pt,
  fill: if (ok) {green} else {red},
  width: 100%,
  radius: 6pt,
  text(white, weight: "bold", body)
)

= Analysis <analysis>
// - Beschreibung des System-Kontexts
// - Funktionale und nicht-Funktionale Anforderungen
// - Use Cases/Scenarios/User Storys
// - Bestehende Infrastruktur
// - Abhängig vom Projekt: Risikoanalyse
// - Beschreibung (externen) existierenden Schnittstellen

This section documents the research and analysis of various processes and constructs.
First, in @refactoring_explanation, it is explored what a refactoring is.
Then the language server protocol is described in @lsp_analysis.

@llvm_project_analysis analyzes the structure of the LLVM project.
The clangd language server is looked at in @clangd_language_server_analysis, with a focus on refactorings, including their testing in @refactor_operations_in_clangd.

In @ast_analysis, abstract syntax trees are looked at, including their role in compilers and clang specifically.

Finally, C++ concepts are examined in @cpp_concepts.


== Refactoring <refactoring_explanation>

When applying a refactoring, the behavior needs to stay the same as before the refactoring was applied.
To ensure that a refactoring does not affect the behavior, an inductive proof can be used.
However, in practice this is rarely done.
Instead, unit tests can be used to get at least some assurance of the behavior, which is the case in the clangd language server.
One would theoretically still be required to proof that the expected result has the same behavior as the test input,
however, due to these tests being very concise, their correctness can typically be verified through a quick inspection.
The testing of refactorings is explored in more detail in @testing.

In @refactoring_bad_example an example of a bad refactoring is shown.
A function is defined with the template type parameters `T` and `U` and the function parameters `p1` and `p2`, which use the template type parameters in reverse order.
If a refactoring, for example one which converts the functions to their abbreviated form using `auto` parameters, would blindly use `auto` for all function parameter types, it would result in a different function signature.
The compiler will then throw an error at the call-site, because the function call is no longer valid.

#figure(
  kind: table,
  [
  #set text(size: 0.9em)
  #grid(
    columns: (2fr, 1fr, 1fr),
    gutter: 1em,
    [],
    [*Identical Parameter Types*],
    [*Different Parameter Types*],
    [],
    [
       ```cpp
      f<int, int>
      (24, 42);
      ```
    ],
    [
       ```cpp
      f<string, int>
      (42, "?");
      ```
    ],
    [
      ```cpp
      // Before Refactoring
      template <typename T, std::integral U>
      void f(U p1, T p2)
      {}
      ```
    ],
    [
      #cell(ok:true)[Compiles]
    ],
    [
      #cell(ok:true)[Compiles]
    ],
    [
      ```cpp
      // After Refactoring
      void f(auto std::integral p1, auto p2)
      {}
      ```
    ],
    [
      #cell(ok:true)[Compiles]
    ],
    [
      #cell(ok:false)[Not Compiling]
      Template arguments do no longer fulfill the concept requirement.
    ],
  )],
  caption: [
    Bad example of refactoring
  ],
) <refactoring_bad_example>
// what does it mean implementation wise
// how to ensure that code logic isn't changed after refactoring is applied

== Language Server Protocol (LSP) <lsp_analysis>

// Note Corbat: Standard-Set an Features und erweiterbar...
The language server protocol, short LSP, is an open, JSON-RPC based protocol designed to communicate between code editors or integrated development environments (IDEs) and language servers.
It provides language-specific features such as code completion, syntax highlighting, error checking, and other services to enhance the capabilities of code editors.
Traditionally this work was done by each development tool as each provides different APIs for implementing the same features.

@language_server_sequence shows an example for how a tool and a language server communicate during a routine editing session.

The development tool sends notifications and requests to the language server. 
The language server can then respond with the document URI and position of the symbol's definition inside the document for example.

#figure(
  image("../images/language_server_sequence.png"),
  caption: [
    Diagram showing example communication between IDE and language server @lsp_overview
  ],
) <language_server_sequence>

By using a common protocol the same language server can be used by different editors which support the protocol.
This reduces the effort required to integrate language-specific features into various development environments,
allowing developers to have a more efficient and feature-rich coding experience, regardless of the programming language they are working with. 

The idea of the LSP as described by Microsoft:

#quote(attribution: [#cite(<lsp>, form: "author" )], block: true)[
The idea behind the Language Server Protocol (LSP) is to standardize the protocol for how such servers and development tools communicate. This way, a single Language Server can be re-used in multiple development tools, which in turn can support multiple languages with minimal effort.
]

Language servers are used within modern IDEs and code editors such as Visual Studio Code, Atom and Sublime Text.

#pagebreak()

/ Implementations: #[
The language servers implementing the LSP for C++ are shown in @cpp-implementation.
For this project, the focus is set on the LLVM project, which is explored in @llvm_project_analysis.

A list of tools supporting the LSP can be found on the official website @tools_supporting_lsp.

#figure(
  kind: table,
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
These steps are the same for all tools using the LSP.

+ Action Request
+ Execute Command
+ Apply Edit

The flow chart @lsp-sequence-diagram shows a quick overview of the requests used for refactoring features.
The details of the requests shown in the flow diagram are explained further in the following sections.

#figure(
  image("../images/lsp_sequence_diagram.png", width: 80%),
  caption: [
    Diagram showing code action and code action resolve request
  ],
) <lsp-sequence-diagram>

/ Code Action Request: #[
The code action request is sent from client to server to compute commands for a given text document and range.
To make the server useful in many clients, the command actions should be handled by the server and not by the client.

A client first needs to request possible code actions.

// TODO: add json of code action request (Client -> Server)

The server then computes which ones apply and sends them back in a JSON-encoded response.
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
To apply a code change the client sends a `workspace/executeCommand` to the server.
The server can then create one or multiple workspace edit structures @lsp_workspace_edit and apply the changes to the workspace by sending a `workspace/applyEdit` @lsp_workspace_apply_edit command to the client.

// TODO: add json of executeCommand request (Client -> Server)
]

/ Apply a WorkspaceEdit: #[
  The `workspace/applyEdit` command is sent from the server to the client to modify a resource on the client side.

  When the client then applies the provided changes and reports back to the server whether the edit has been successfully applied or not.

  // TODO: add json of applyEdit (Server -> Client)
]

== LLVM Project <llvm_project_analysis>
The LLVM project @llvm_github is a collection of modular and reusable compiler and toolchain technologies.
One of the primary sub-projects is Clang which is a "LLVM native" C/C++/Objective-C compiler.

@llvm_illustration illustrates how different compilers can use the LLVM intermediate language as an intermediate step before being compiled to platform-specific code.

#figure(
  image("../images/llvm_architecture.jpeg", width: 80%),
  caption: [
    Diagram showing architecture of LLVM @LLVM_compiler_architecture
  ],
) <llvm_illustration>

Code refactorings for C++ can be found within the clangd language server which is based on the clang compiler. @clangd

/ Coding Guidelines : #[
As all big projects LLVM also has defined coding guidelines @llvm_coding_standards which should be followed.
The documentation is written really well and is easy to understand which makes it easy to follow.
A lot of guidelines are described, however some things seem to be missing like the usage of trailing return types introduced with C++ 11 @function_declaration.
]

/ Code Formatter : #[
To fulfill the formatting guidelines there is a formatter `clang-format` @clang_format within the project to format the files according to the guidelines.
A check run on GitHub is ensuring that the format of the code is correct.
Only when the formatter has been run successfully a pull request is allowed to be merged.
]

== The clangd Language Server <clangd_language_server_analysis>

// Note Corbat: Aufbau des ganzen Toolings? Welche anderen Komponenten gibt es? Wie hängen diese zusammen?
// TODO: wie gelangt language server an den code

Clangd is the language server which lives in the LLVM project repository @llvm_github under `clang-tools-extra/clangd`.
It understands C++ code and provides smart features like code completion, compiler warnings and errors, as well as go-to-definition and find-references capabilities.
The C++ refactoring features can be found within clangd under the `tweaks` folder.

== Refactorings in clangd <refactor_operations_in_clangd>

// Note Corbat: Was ist ein Refactoring?
// Note Corbat: Gibt es noch andere Teile, die relevant sein könnten für jemanden der ein Refactoring implementiert?
Each refactoring operation within clangd is implemented as a class, which inherits from a common `Tweak` ancestor.

The LLVM project is quite big and it took a while to figure out how it is structured.
For refactoring features, classes can be created in `llvm-project/clang-tools-extra/clangd/refactor/tweaks`.

Looking at the existing refactoring features no feature could be found specific to concepts.
Some basic ones like symbol rename already work for them.
As concepts were introduced with C++20 it is quite new to the world of C++ and therefore not much of support exists yet.

For other operations refactoring operations already exist (e.g. renaming).
Looking at existing refactoring code helped to understand how a refactoring is structured and implemented.

=== Testing <testing>
The LLVM project strictly adheres to a well-defined architecture for testing. 
To align with project guidelines @clangd_testing, automated unit tests must be authored prior to the acceptance of any code contributions.
The name of these files is usually the name of the class itself and uses the googletest framework @googletest_framework.

Unit tests for tweaks are added to `llvm-project/clang-tools-extra/clangd/unittests`.
To test them three functions are typically used, `EXPECT_EQ`, `EXPECT_AVAILABLE`, and `EXPECT_UNAVAILABLE`.

/ `EXPECT_EQ` : #[
  Executes the `apply` function for a given snippet at a given cursor location and compares the result with the expected code.
]

/ `EXPECT_AVAILABLE` : #[
  Checks if the refactoring feature is available on certain cursor position within the code.
  The `prepare` function is executed.
]

/ `EXPECT_UNAVAILABLE` : #[
  Checks if the refactoring feature is unavailable on certain cursor position within the code.
  The `prepare` function is executed.
]

=== Code Actions

All refactoring features, so called "tweaks", reside in the `refactor/tweaks` directory, where they are registered through the linker. 
These compact plugins inherit the tweak class which acts as an interface base.
// TODO: Das liesse sich schön visualisieren.
When presented with an AST and a selection, they can swiftly assess if they are applicable and, if necessary, create the edits, potentially at a slower pace.
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
    Structure of a tweak class
  ],
) <tweak_structure>

*```cpp bool prepare(const Selection &Inputs)```:* \
Within the `prepare` function a check is performed to see if a refactoring is possible on the selected area.
The function is returning a boolean indicating whether the action is available and should be shown to the user.
As this function should be fast only non-trivial work should be done within.
If the action requires non-trivial work it should be moved to the `apply` function.

// TODO check if this is correct
For example, in Visual Studio Code the function is triggered as soon as the "Refactoring" option is used.

*```cpp Expected<Tweak::Effect> apply(const Selection &Inputs)```:* \
Within the `apply` function the actual refactoring is taking place.
The function is triggered as soon as the refactoring tweak has ben selected.
// Kommentar Jeremy: Erkläre wieso, zb dass mer privati variable initialized.
It is expected that the `prepare` function has been called before to ensure that the second part of the action is working without problems.

It returns the effect which should be applied on the client side.

== Abstract Syntax Tree (AST) <ast_analysis>

The Abstract Syntax Tree, short AST, is a syntax tree representing the abstract syntactic structure of a text.
It represents the syntactic structure of source code written in a programming language, capturing its grammar and organization in a tree-like form.
It provides a structured way to analyze and manipulate code, making it easier for tools like code analyzers, code editors, and IDEs to understand and work with the code. @ast_twilio

The tree underpinning the AST is a structure consisting of a root node, which is the starting node on top of the tree, which then points to other values and these values to others as well.
@ast_structure shows a simple tree.

Each circle is representing a value which is referred to as 'node'.
The relationship within the tree can be described by using names like 'parent node', 'child node', 'sibling node' and so on.

To illustrate how source code gets mapped to an AST we can look at an example.
@fact_function shows a simple function that calculates the factorial of n along with a possible AST for it.

#figure(
  image("../drawio/ast_structure.drawio.png", width: 50%),
  caption: [
    Diagram showing tree structure
  ],
) <ast_structure>

#[
#set align(horizon)
#figure(
  stack(
    dir: ltr,
    spacing: 20pt,
      ```cpp
      int fact(int n) {
        if (n == 0)
            return 1;
        else
            return n*fact(n-1);
      }
      ```,
    image("../images/ast_fact_function.png", width: 35%),
  ),
  caption: [
    Function for calculating factorial of a number
  ],
) <fact_function>
]

#pagebreak()

The most common use for ASTs are with compilers.
For a compiler to transform source code into compiled code, three steps are needed.

+ *Lexical Analysis* - Convert code into set of tokens describing the different parts of the code. 
+ *Syntax Analysis* - Convert tokens into a tree that represents the actual structure of the code.
+ *Code Generation* - Generate code out of the abstract syntax tree.

@code_generation shows a visualization of the conversion steps.

In Clangd, the "AST" refers to the AST generated by the Clang compiler for a C++ source file.
Clangd uses this AST to provide features like code completion, code navigation, and code analysis in C++ development environments.

Clang also has a builtin AST-dump mode, which can be enabled with the `-ast-dump` flag. @clang_ast
@clang_ast_example shows an example of the ast dump of a simple function.

#figure(
  image("../images/ast_generation.png", width: 90%),
  caption: [
    Diagram showing steps for code generation @ast_python
  ],
) <code_generation>

#figure(
  [
    #set text(size: 0.9em)
    ```
    $ cat test.cc
    int f(int x) {
      int result = (x / 42);
      return result;
    }

    # Clang by default is a frontend for many tools; -Xclang is used to pass
    # options directly to the C++ frontend.
    $ clang -Xclang -ast-dump -fsyntax-only test.cc
    TranslationUnitDecl 0x5aea0d0 <<invalid sloc>>
    ... cutting out internal declarations of clang ...
    `-FunctionDecl 0x5aeab50 <test.cc:1:1, line:4:1> f 'int (int)'
      |-ParmVarDecl 0x5aeaa90 <line:1:7, col:11> x 'int'
      `-CompoundStmt 0x5aead88 <col:14, line:4:1>
        |-DeclStmt 0x5aead10 <line:2:3, col:24>
        | `-VarDecl 0x5aeac10 <col:3, col:23> result 'int'
        |   `-ParenExpr 0x5aeacf0 <col:16, col:23> 'int'
        |     `-BinaryOperator 0x5aeacc8 <col:17, col:21> 'int' '/'
        |       |-ImplicitCastExpr 0x5aeacb0 <col:17> 'int' <LValueToRValue>
        |       | `-DeclRefExpr 0x5aeac68 <col:17> 'int' lvalue ParmVar 0x5aeaa90 'x' 'int'
        |       `-IntegerLiteral 0x5aeac90 <col:21> 'int' 42
        `-ReturnStmt 0x5aead68 <line:3:3, col:10>
          `-ImplicitCastExpr 0x5aead50 <col:10> 'int' <LValueToRValue>
            `-DeclRefExpr 0x5aead28 <col:10> 'int' lvalue Var 0x5aeac10 'result' 'int'
    ```
  ],
  caption: [
    Example of AST dump in clang @clang_ast
  ]
) <clang_ast_example>

#pagebreak()

When building an AST a root node needs to be found.
In clang, the top level declaration in a translation unit is always the `translation unit declaration` @clang_translation_unit_decl.
For a function for example it would be the `function declaration` @clang_function_declaration.
When the code has errors the AST can only be built if the toplevel declaration is found.
For a function this means, that the function name has to be present but other than that it can have errors within the code.

@ast_dump_possibilities shows in which cases the AST can or can not be built.

#figure(
  kind: table,
  grid(
    columns: (auto, 14em),
    gutter: 1em,
    align(start + horizon)[
      ```cpp
      int f(int x) {
        int result = (x / 42);
        return result;
      }
      ```
    ],
    align(horizon)[
      #cell(ok:true)[OK]
    ],
     align(horizon)[
      ```cpp
      f(int x) {
        int result = (x / 42);
        return result;
      }
      ```
    ],
    align(horizon)[
      #cell(ok:true)[OK]
    ],
     align(start + horizon)[
      ```cpp
      int f(int x) {
        int result = (x / 42);
      }
      ```
    ],
     align(horizon)[
      #cell(ok:true)[OK]
    ],
    align(start + horizon)[
      ```cpp
      int f {
        int result = (x / 42);
        return result;
      }
      ```
    ],
    align(horizon)[
      #cell(ok:true)[OK]
    ],
    align(start + horizon)[
      ```cpp
      int (int x) {
        int result = (x / 42);
        return result;
      }
      ```
    ],
    align(horizon)[
      #cell[NOT OK \ function name missing]
    ],
     align(horizon)[
      ```cpp
      int f(int x) 
        int result = (x / 42);
        return result;
      ```
    ],
    align(horizon)[
      #cell[NOT OK \ function brackets missing]
    ],
  ),
  caption: [
    AST dump possibilities for valid and invalid functions
  ],
) <ast_dump_possibilities>

== C++ Concepts <cpp_concepts>

Concepts are a new language feature introduced with C++20.
They allow puttign constraints on template parameters, which are evaluated at compile time.
This allows developers to restrict template parameters in a new convenient way.
For this the keywords `requires` @keyword_requires and `concept` @keyword_concept were added to give some language support. @concepts

Before C++20 `constexpr` and `if constexpr` were used for such restrictions, more about these can be found in the C++ stories @if_const_expr.

/ Usage of the `requires` keyword : #[
  The `requires` keyword can be used either before the function declaration or between the function declaration and the function body as illustrated in @requires_keyword_usage.
  The requirements can also contain disjunctions (`||`) and/or conjunctions (`&&`) to restrict the parameter types even more.
  Examples for these can be found in @concept_conditions_or and @concept_conditions_and.
]

/ Usage of the `concept` keyword : #[
  Using the `concept` keyword requirements can be named, so they do not have to be repeated for every `requires` clause.
  An example for a concept declaration can be found in @concept_decleration_example.
]

#v(1cm)

#figure(
  kind: image,
  grid(
    columns: (auto, 14em),
    gutter: 1em,
    ```cpp
    template <typename T>
    requires CONDITION
    void f(T param)
    {}
    ```,
    ```cpp
    template <typename T>
    void f(T param) requires CONDITION
    {}
    ```
  ),
  caption: [
    Functions using requires clause
  ],
) <requires_keyword_usage>

#figure( ```cpp
  requires std::integral<T> || std::floating_point<T>
  ```,
  caption: [
    Requires clause using disjunction
  ],
) <concept_conditions_or>

#figure(
  ```cpp
  requires std::integral<T> && std::floating_point<T>
  ```,
  caption: [
    Requires clause using conjunction
  ],
) <concept_conditions_and>

#figure(
  ```cpp
  template<typename T>
  concept Hashable = requires(T a)
  {
      { std::hash<T>{}(a) } -> std::convertible_to<std::size_t>;
  };
  ```,
  caption: [
    Hashable concept declaration
  ],
) <concept_decleration_example>
