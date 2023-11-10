= Analysis <analysis>
// - Beschreibung des System-Kontexts
// - Funktionale und nicht-Funktionale Anforderungen
// - Use Cases/Scenarios/User Storys
// - Bestehende Infrastruktur
// - Abhängig vom Projekt: Risikoanalyse
// - Beschreibung (externen) existierenden Schnittstellen

// Kommentar Jeremy: Das sett mer vermuetli splitte in "what is llvm" und "what is a language server"
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

// Kommentar Jeremy: Mer settet links ned eifach so dinne ha, es sett alles ide bibliographie si
Clangd is the language server which lives in the #link("https://github.com/llvm/llvm-project")[llvm-project] repository under `clang-tools-extra/clangd`. For this project the goal is to add refactoring features which can be found within the clangd folder `tweaks`.

// Kommentar Jeremy: Das chammer eigentlich es level ufe neh (2 statt 3) und obe am "clangd language server" chapter here tue.
=== Language Server Protocol

The Language Server Protocol (LSP) is an open, JSON-RPC based protocol designed to communicate between code editors or integrated development environments (IDEs) and language servers, which provide language-specific analysis, completion, and other coding features.
The defined 

For this project the Code Action Request and the Code Action Resolve Request are used.

// https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#textDocument_codeAction

// https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#codeAction_resolve

// Kommentar Jeremy: Vellecht no 1-2 Sätz dass mers ide folgende Absätz werdet erlütere?
#figure(
  image("../images/lsp-sequence-diagram.png", width: 80%),
  caption: [
    diagram showing Code Action and Code Action Resolve Request
  ],
)

==== Code Action Request

The code action request is sent from client to server to compute commands for a given text document and range.
To make the server useful in many clients, the command actions should be handled by the server and not by the client.
// Kommentar Jeremy: Die Zile grad obe a dem Kommentar isch irgendwie chli redundant, da hemmer ja scho in de introduction.

==== Code Action Resolve Request

The Resolve Request is sent from the client to the server to resolve additional information for a given code action.

// Kommentar Jeremy: Mer sett no sege wie jetz de command usgfüert wird. Bis jetz erkläre mer nur wiemer dezue chonnt.
// Kommentar Jeremy: Im debugger luege ob resolve request überhaupt usgfüert wird

== Coding Guidelines

As all big projects LLVM also has defined coding guidelines which should be followed.
// Kommentar Jeremy: Link id bibliographie
The documentation is written really well and can be found #link("https://llvm.org/docs/CodingStandards.html")[here].
A lot of guidelines are written down but some things seem to be missing. 
While refactoring the first feature the question came up if trailing returns should be used or not.
Unfortunately this is not described within the coding guidelines.

=== Code Formatter
To fulfill the formatting guidelines there is a formatter within the project which styles the files according to the guidelines.
To ensure that the format is correct, a check is run on GitHub for Pull-Requests, which can only be merged if the check is succesful.

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
// TODO: Bibliographie
The LLVM project strictly adheres to a well-defined architecture for testing. To align with #link("https://clangd.llvm.org/design/code.html#testing")[project guidelines], automated unit tests must be authored prior to the acceptance of any code contributions. 
// TODO: Bibliographie
The name of these files is usually the name of the class itself and use the #link("https://clangd.llvm.org/design/code.html#testing")[googletest framework].

Unit tests are added to `llvm-project/clang-tools-extra/clangd/unittests`

// TODO: explain test concept of clangd (for tweaks)

#pagebreak()

=== Code Actions
// Kommentar Jeremy: Was isch "LSP system"?
// Kommentar Jeremy: C++ het kei interfaces
Tweaks supply the majority of code actions in the LSP system. These compact plugins implement the Tweak interface and reside in the `refactor/tweaks` directory, where they are registered through the linker. 
When presented with a selection, they can swiftly assess if they are applicable and, if necessary, create the edits, potentially at a slower pace.
These fundamental components constitute the foundation of the LSP code-actions flow.

Each tweak has it's own class and is structured as follows:

// Kommentar Jeremy: Code size vellecht chli chlinner mache
// Kommentar Jeremy: Listing

#[
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
]

// Kommentar Jeremy: Da isch ned ganz korrekt, zersch wird prepare ufgrüeft.
// Kommentar Jeremy: Es wird en array an actions zrugg gschickt, ned "tweak class as json".
When the client requests the list of possible code actions, the tweak classes are being converted to JSON and then sent to the client.
The above class could look like this when it is sent to the client:

// Kommentar Jeremy: Code size vellecht chli chlinner mache
// Kommentar Jeremy: Listing
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

== AST

// Kommentar Jeremy: Weiss ned obs nötig isch de "AST Tree" erwähne, mer nennets glaub scho überall suscht AST.
In Clangd, the "AST tree" refers to the Abstract Syntax Tree (AST) generated by the Clang compiler for a C++ source file.
The AST tree is a hierarchical representation of the code structure, capturing the syntax and semantics. 
It provides a structured way to analyze and manipulate the code, making it easier for tools like code analyzers, code editors, and IDEs to understand and work with C++ code.
Clangd uses this AST tree to provide features like code completion, code navigation, and code analysis in C++ development environments.
