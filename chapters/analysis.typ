= Analysis <analysis>
// - Beschreibung des System-Kontexts
// - Funktionale und nicht-Funktionale Anforderungen
// - Use Cases/Scenarios/User Storys
// - Bestehende Infrastruktur
// - Abhängig vom Projekt: Risikoanalyse
// - Beschreibung (externen) existierenden Schnittstellen

== What is a Language Server?

To fulfill the project goal it is important to know what LLVM is and how it works. 
An image should help to understand the architecture:

#figure(
  image("../images/llvm_architecture.jpeg", width: 80%),
  caption: [
    diagram showing architecture of LLVM, @LLVM_compiler_architecture
  ],
)

== The clangd Language Server

Clangd is the language server which lives in the #link("https://github.com/llvm/llvm-project")[llvm-project] repository under `clang-tools-extra/clangd`. For this project the goal is to add refactoring features which can be found within the clangd folder `tweaks`.

=== Language Server Protocol

The Language Server Protocol (LSP) is an open, JSON-RPC based protocol designed to communicate between code editors or integrated development environments (IDEs) and language servers, which provide language-specific analysis, completion, and other coding features.
The defined 

For this project the Code Action Request and the Code Action Resolve Request is used.

// https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#textDocument_codeAction

// https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#codeAction_resolve

#figure(
  image("../images/lsp-sequence-diagram.png", width: 80%),
  caption: [
    diagram showing Code Action and Code Action Resolve Request
  ],
)

==== Code Action Request

The code action request is sent from client to server to compute commands for a given text document and range.
To make the server useful in many clients, the command actions should be handled by the server and not by the client.

==== Code Action Resolve Request

The Resolve Request is sent from the client to the server to resolve additional information for a given code action. 

== Coding Guidelines

As all big projects the LLVM also has defined coding guidelines which should be followed.
The documentation is written really well and can be found #link("https://llvm.org/docs/CodingStandards.html")[here].
A lot of guidelines are written down but some things seem to be missing. 
While refactoring the first feature the question came up if trailing returns should be used or not.
Unfortunately this case is not described within the coding guidelines and after looking at other code snippets it was decided to stick with the non trailing version of return values.

=== Code Formatter
To fulfill the formatting guidelines there is a formatter within the project which styles the files according to the guidelines.

To check ensure that the format is correct, a job is running on GitHub for Pull-Request.
The Pull-Request can only be merged if the job finishes successfully.

// TODO: add link

== Refactorings in clangd
Each refactoring option within clangd has its own class.

=== Project Structure

The LLVM project is quite big and it took a while to figure out how it is structured.
For refactoring features classes can be created in the following directory: \
`llvm-project/clang-tools-extra/clangd/refactor/tweaks`.

=== Existing Refactorings
Looking at the refactoring features no feature could be found which can be used on concepts.
As concepts were introduced with C++20 it is quite to the world of C++ and therefore not much of support exists yet.

For other scenarios multiple refactorings already exist e.g. switching statements within an if.
Looking at the existing refactoring code helped to understand the how a refactoring is done.

=== Testing <testing>
The LLVM project strictly adheres to a well-defined architecture for testing. To align with #link("https://clangd.llvm.org/design/code.html#testing")[project guidelines], automated unit tests must be authored prior to the acceptance of any code contributions. 
The name of the files is usually the name of the class itself and use the #link("https://clangd.llvm.org/design/code.html#testing")[googletest framework].

Unit tests are added to `llvm-project/clang-tools-extra/clangd/unittests`

// TODO: explain test concept of clangd (for tweaks)

#pagebreak()

=== Code Actions

Tweaks supply the majority of code actions in the LSP system. These compact plugins implement the Tweak interface and reside in the `refactor/tweaks` directory, where they are registered through the linker. 
When presented with a selection, they can swiftly assess if they are applicable and, if necessary, create the edits, potentially at a slower pace.
These fundamental components constitute the foundation of the LSP code-actions flow.

Each tweak has it's own class and is structured as follows:

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

When the client requests the list of possible code actions, the tweak classes are being converted to JSON and then sent to the client.
The above class could look like this when it is sent to the client:

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

// TODO: describe from LSP perspective
*```cpp bool prepare(const Selection &Inputs)```:* \
Within the `prepare` function it needs to be checked if a refactoring is possible on the selected area.
The function is returning a boolean indicating wether the action is available and should be shown to the user.
As this function should be fast only non-trivial work should be done within.
If the action requires trivial work it should be moved to the `apply` function.

// TODO check if this is correct
The function is triggered as soon as the "Refactoring" option within the Visual Studio Code is used.

*```cpp Expected<Tweak::Effect> apply(const Selection &Inputs)```:* \
Within the `apply` function the actual refactoring is taking place.
The function is triggered as soon as the refactoring tweak has ben clicked.
It is expected that the `prepare` function has been called before to ensure that the second part of the action is working without problems.

It returns the effect which should be done on the clients side.

== AST

In Clangd, the "AST tree" refers to the Abstract Syntax Tree (AST) generated by the Clang compiler for a C++ source code file. The AST tree is a hierarchical representation of the code's structure, capturing the syntax and semantics of the code. 
It provides a structured way to analyze and manipulate the code, making it easier for tools like code analyzers, code editors, and IDEs to understand and work with C++ code. 
Clangd uses this AST tree to provide features like code completion, code navigation, and code analysis in C++ development environments.
