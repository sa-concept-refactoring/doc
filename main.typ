#import "@preview/tablex:0.0.4": tablex, colspanx, rowspanx, cellx
#import "progress-bar.typ": printProgressBar

#import "title-page.typ": luschtig
#include "title-page.typ"

#show raw: it => {
  if (it.block) {
    block(
      fill: luma(0xF0),
      inset: 8pt,
      radius: 5pt,
      text(it)
    )
  } else {
    text(it)
  }
}

#show heading: it => {
  if (it.level == 1) {
    pagebreak()
  }
  it
}

#set text(font: ("Comic Sans MS")) if luschtig

#set page(numbering: "1 / 1") if not luschtig

#set page(
  footer: [
    #locate(loc => {
      let pageCounter = counter(page)
      let total = pageCounter.final(loc).first()
      let current = pageCounter.at(loc).first()
      printProgressBar(current / total, label: {str(current) + "/" + str(total)})
    })
  ],
) if luschtig

= Abstract
// TODO

// Der Abstract richtet sich an den Spezialisten auf dem entsprechenden Gebiet und beschreibt
// daher in erster Linie die (neuen, eigenen) Ergebnisse und Resultate der Arbeit. (Aus
// Anleitung Dokumentation FS21 vom SG-I).
// - Der Umfang beträgt in der Regel eine halbe Seite Text
// - Keine Bilder

= Management Summary

// - Das Management Summary richtet sich in der Praxis an die "Chefs des Chefs", d.h. an die
// Vorgesetzten des Auftraggebers (diese sind in der Regel keine Fachspezialisten). Die Sprache
// soll knapp, klar und stark untergliedert sein. (Aus Anleitung Dokumentation FS21 vom SG-I)
// - Der Umfang beträgt in der Regel 3-5 Seiten.
// - Bilder sind hier sinnvoll

#outline(
  title: "Table of Contents",
  indent: auto,
  target: heading.where(level: 1).or(heading.where(level: 2))
)

#set heading(numbering: "1.")
#show par: set block(below: 2em)
#show figure: set block(below: 2em)

= Introduction

// - Beschreibung der Ausgangslage
// - Beschreibung der Aufgabe
// - Rahmenbedingungen
// - Vorarbeiten
// - Übersicht über die kommende Kapitel

== Initial Situation
The LLVM project @llvm_github is an open source repository on GitHub and contains the source code for LLVM, a toolkit for the construction of highly optimized compilers, optimizers, and run-time environments. 

== Problem Description
As of the new changes of C++20 type constraints were introduced. 
For this new added feature not many refactoring options do currently exist which should be changed with our SA.

== Project Goal
The goal of this project is to contribute a refactoring feature to the LLVM project, for the newly added type constraints for C++.

// TODO where to place this? Is it needed?
= Structure of This Report
This report encompasses the analysis, elaboration, and implementation of the project's work. It is structured into the following sections:

// TODO descibe chapers

= Analysis
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
  image("images/llvm_architecture.jpeg", width: 80%),
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
  image("images/lsp-sequence-diagram.png", width: 80%),
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
The function is returning a boolean indicating wether the action is availible and should be shown to the user.
As this function should be fast only non-trivial work should be done within.
If the action requires trivial work it should be moved to the `apply` function.

// TODO check if this is correct
The function is triggered as soon as the "Refactoring" option within the Visual Studio Code is used.

*```cpp Expected<Tweak::Effect> apply(const Selection &Inputs)```:* \
Within the `apply` function the actual refactoring is taking place.
The function is triggered as soon as the rafactoring tweak has ben clicked.
It is expected that the `prepare` function has been called before to ensure that the second part of the action is working without problems.

It returns the effect which should be done on the clients side.

== AST

In Clangd, the "AST tree" refers to the Abstract Syntax Tree (AST) generated by the Clang compiler for a C++ source code file. The AST tree is a hierarchical representation of the code's structure, capturing the syntax and semantics of the code. 
It provides a structured way to analyze and manipulate the code, making it easier for tools like code analyzers, code editors, and IDEs to understand and work with C++ code. 
Clangd uses this AST tree to provide features like code completion, code navigation, and code analysis in C++ development environments.

= Refactoring Ideas

== Requirement Transformation <first_idea>
A new refactoring could be provided to transform a function template using concepts between alternate forms.
@transformation_idea_listing shows the different forms.

#figure(
  grid(
    columns: (auto, auto),
    gutter: 1em,
    align(start + horizon)[
      ```cpp
      template<Hashable T>
      void f(T) {}
      ```
    ],
    align(start + horizon)[
      ```cpp
      template<typename T>
      void f(T) requires Hashable<T> {}
      ```
    ],
    align(start + horizon)[
      ```cpp
      void f(Hashable auto x) {}
      ```
    ],
    align(start + horizon)[
      ```cpp
      template<typename T> requires Hashable<T>
      void f(T) {}
      ```
    ],
  ),
  caption: [
    Different ways to constrain a function template using concepts
  ],
) <transformation_idea_listing>

== Extraction of Conjunctions and Disjunctions
Sometimes more than one constraint is used in a ```cpp requires``` clause.
This is expressed by `||` and `&&` operators.
The proposed refactoring would offer to extract these logical combinations into a new named concept.

#figure(
  ```cpp
  template <typename T>
  void bar(T a) requires std::integral<T> && Hashable<T> {
    ...
  }
  ```,
  caption: [ An existing conjunction ],
) <conjunction_idea_listing>

#figure(
  ```cpp
  template<class T>
  concept NAME = std::integral<T> && Hashable<T>;

  template <typename T>
  void bar(T a) requires NAME<T> {
    ...
  }
  ```,
  caption: [ The proposed refactoring to the conjunction in @conjunction_idea_listing ],
)

#pagebreak()

== Concept Simplification <third_idea>

With shortcuts and terse syntax concepts can be simplified.

More details about the code simplification can be found here: #link("https://www.cppstories.com/2021/concepts-intro/#code-simplification").

Unconstrained `auto` can be used to replace `T`:

#figure(
  ```cpp
  template <std::integral T>
  auto f(T) -> void {}
  ```, 
caption: [Example of a concept]
)

#figure(
  ```cpp
    auto f(auto Tpl) -> void {}
  ```,
caption: [Simplified concept]
)

// TODO: @vina this is somehow not possible, check why
Also when using `concept` within the requires clause it can be simplified for example: 

#figure(
  ```cpp
  template <typename T>
  requires concept<T>
  auto func(T param) { }
  ```,
caption: [Example of a concept with concept requirement]
)

#figure(
  ```cpp
  auto func(concept auto param) { }
  ```,
caption: [Simplified concept without requires clause]
)

= First Refactoring (Inline Concept Requirement)
For the first refactoring a subset of the initial idea (@first_idea) was implemented.
The patch has also been submitted upstream as a pull request on GitHub @pull_request_of_first_refactoring.

Only simple cases are handled for now, however the functionality could easily be expanded upon in the future.
The restrictions for now are that only function templates are supported and conjunctions & disjunctions of concept requirements are not.

Some examples of what this refactoring can do as of now can be found in the table below.

#figure(
  table(
    columns: (1fr, 1fr),
    align: horizon,
    [*Before*], [*After*],
    ```cpp
    template <typename T>
      void f(T) requires foo<T> {}
    ```,
    ```cpp
    template <foo T>
    void f(T) {}
    ``` ,
    ```cpp
    template <typename T>
    requires foo<T>
    void f(T)
    ```,
    ```cpp
    template <foo T>
    void f(T) {}
    ```,
    ```cpp
    template <template <typename> class Foo, typename T>
    void f() requires std::integral<T> {}
    ```,
    ```cpp
    template <template <typename> class Foo, std::integral T> 
    void f() {}
    ```,
  ),
  caption: "Capabilities of the first refactoring",
)

== Testing

To test the implementation unit tests were written as described in @testing. \
There are a total of 11 tests, which consist of the following:
- 4 availability tests
- 4 unavailability tests
- 3 application tests

#pagebreak()
== Implementation

=== Captured Elements
During the preparation phase the following elements need be captured.
They will be stored as a member of the tweak object and then used during the application phase.

#figure(
  tablex(
    columns: 2,
    auto-vlines: false,
    ```cpp
    template <typename T>
              ^^^^^^^^^^
    void f(T) requires foo<T> {}
    ```,
    [
      *Template Type Parameter Declaration* \
      Will be updated using the concept found in the concept specialization expression below.
    ],
    ```cpp
    template <typename T>
    void f(T) requires foo<T> {}
                       ^^^^^^
    ```,
    [
      *Concept Specialization Expression* \
      Will be removed.
    ],
    ```cpp
    template <typename T>
    void f(T) requires foo<T> {}
              ^^^^^^^^
    ```,
    [
      *Requires Token* \
      Will be removed.
    ],
  ),
  caption: "Elements captured for the first refactoring",
)

=== Considerations
The refactoring should be as defensive as possible and only apply when it is clear that it will apply correctly. The following checks are made during the preparation phase to ensure this.

#figure(
  table(
    columns: (1fr, 1.5fr),
    align: start,
    [*Check*], [*Reasoning*],
    [
      The selected ```cpp requires``` clause only contain a single requirement.
    ],
    [
      Combined concept requirements are complex to handle and would increase the complexity drastically.
    ],
    [
      The selected concept requirement only contain a single type argument.
    ],
    [
      With multiple type arguments inlining would not be possible.
    ],
    [
      The concept requirement has a parent of either a function or a function template.
    ],
    [
      To restrict the refactoring to function templates only.
      This is a temporary restriction that could be lifted in the future.
    ],
  ),
  caption: "Checks made during the first refactoring",
)

=== AST Analysis

To get to know the structure of the code which needs to be refactored, the AST tree gives a good overview.

On the left the AST tree is shown of the code on the right:


#figure(
  table(
    columns: (1fr, 1fr),
    align: center,
    stroke: none,
    [*AST*], [*Code*],
    image("images/screenshot_ast_first_refactoring.png", width: 80%),
    [
      ```cpp
      template<typename T>
      void bar(T a) requires Foo<T> {
        a.abc();
      }
      ```
    ],
  ),
  caption: [
    AST analysis of second refactoring
  ]
)

== Usage
// TODO: Maybe we should document how it appears from a language server perspective. => JSON

==== VS Code
To use the feature the user needs to hover over the requires clause e.g. `std::integral<T>`.
Then right click to show the code options. 
To see the possible refactorings the option "Refactoring" needs to be clicked and then the newly added feature "Inline concept requirement" will appear within the listed options.

#figure(
  image("images/screenshot_inline_concept.png", width: 50%),
  caption: [
    screenshot showing the option to inline the concept requirement
  ],
)

= Second Refactoring (Simplify Concept)

For the second refactoring a subset of the initial idea (@third_idea) was implemented.
The refactoring is replacing the generic parameter `T` with `auto`.
This tweak helps to reduce the amount of lines and makes the code more readable.

Following examples are showing how the code would be refactored.
This refactoring heps reducing the amount 

#figure(
  table(
    columns: (1fr, 1fr),
    align: horizon,
    [*Before*], [*After*],
    [
      ```cpp
      template<std::integral T>
      auto f(T param) -> void
      {}
      ```
    ],
    [
      ```cpp
      auto f(std::integral auto param) -> void
      {}
      ```
    ],
    [
      ```cpp
      template <typename...T>
      auto f(T...p) -> void
      {}
      ```
    ],
    [
      ```cpp
      auto f(auto ...p) -> void
      {}
      ```
    ],
    [
      ```cpp
      template<std::integral T>
      auto f(T const ** p) -> void
      {}
      ```
    ],
    [
      ```cpp
      auto f(std::integral auto const ** p) -> void {}
      ```
    ],
  ),
  caption: "Capabilities of the second refactoring",
)

== Testing
// Note @vina: should we paste the test cases here? 

== Implementation

=== Captured Elements
During the preparation phase the following elements need be captured.
They will be stored as a member of the tweak object and then used during the application phase.

#figure(
  tablex(
    columns: 2,
    auto-vlines: false,
    ```cpp
    template <std::integral T>
    ^^^^^^^^^^^^^^^^^^^^^^^^^^
    auto f(T param) -> void {}
    ```,
    [
      *Template Declaration* \
      Will be removed.
    ],
    ```cpp
    template <std::integral T>
    auto f(T param) -> void {}
           ^
    ```,
    [
      *Type Paramter* \
      Will be replaced with ```cpp std::integral auto```.
    ],
  ),
  caption: "Elements captured for the second refactoring",
)

// Note @vina: "Function Prerequisit" instead of Considerations? The text from the first refactoring can be copied, but this would not be really nice to read
// === Considerations
=== Function Prerequisit

To replace the template type parameter within a template or concept the code needs to be checked if a replacement is possible.

#figure(
  table(
    columns: (1fr, 1.5fr),
    align: start,
    [*Check*], [*Reasoning*],
    [
      The template type paremeter is not used within the body.
    ],
    [
      If the type parameter is used within the body it is unsure if the type can be replaced with `auto` as the logic of the code would be needed to check.
    ],
    [
      A template definition needs to be in place.
    ],
    [
      If the template definition is not present the logic of this refactoring can't be applied.
    ],
    [
      Only one type parameter is used.
    ],
    [
      To keep the refactoring simple it is only supports replacing one type parameter.
    ],
    [
      The parameter type is not used in a `Map`, `Set`, `List`, `Array` or any other collection
    ],
    [
        The `auto` keyword can't be used as type of a collection.
    ],
    [
      No requires clause should be present.
    ],
    [
      As the refactoring is removing the type parameter the `requires` clause would not be valid anymore.
    ]
  ),
  caption: "Checks made during the second refactoring",
)

=== AST Analysis

// NOTE @vina: same problem as above, the text can be copied...
To get to know the structure of the code which needs to be refactored, the AST tree gives a good overview.

On the left the AST tree is shown of the code on the right:
#figure(
  table(
    columns: (1fr, 1fr),
    align: center,
    stroke: none,
    [*AST*], [*Code*],
    image("images/screenshot_ast_second_refactoring.png", width: 80%),
    [
      ```cpp
      template<std::integral T>
      auto f(T param) -> void
      {}
      ```
    ],
  ),
  caption: [
    AST analysis of second refactoring
  ],
)


== Usage

= Development Process

== Workflow

#figure(
  image("drawio/project-organisation.drawio.svg", width: 100%),
  caption: [
    diagram showing structure and workflow of the project
  ],
)

=== Git
To make life easier it was decided to create a repository on Github and make the whole work open source. 
As there was an already existing pipeline from the original llvm project it self the decision came rather quick as otherwise there could have popped up a lot of different problems and issues.

== Setup
To build clangd, CLion was used as an IDE since it has great support for CMake as well as very good autocomplete, search and debugging capabilities.
VS Code with the clangd extension @clangd_extension and cmake extension @cmake_extension was then configured to use the locally built language server using the `clangd.path` setting.

*`settings.json`:*
```cpp
{
    // Windows
    "clangd.path": "..\\llvm-project\\llvm\\cmake-build-release\\bin\\clangd.exe"

    // Linux
    "clangd.path": "../llvm-project/llvm/cmake-build-release/bin/clangd"
}
```

*Building Clangd in CLion:*
+ Clone project from GitHub https://github.com/llvm/llvm-project
	- `git clone git@github.com:llvm/llvm-project.git`
+ Open llvm project in CLion
+ Open folder `llvm/CMake.txt` in CLion and execute cmake
+ File -> Settings -> Build, Execution, Deployment -> CMake -> CMake options
	- add `-DLLVM_ENABLE_PROJECTS='clang;clang-tools-extra'`
+ Choose "clangd" in target selector and start building

After the clangd build is completed the language server within VS Code needs to be restarted to use the current build.
+ Ctrl. + p : `>Restart language Server`


_Note:_ When using Windows, all programs using clangd.exe have to be closed to be able to build clangd successfully.
In this example this applies to VSCode.

=== Windows

The project was built using ninja and Visual Studio.

The Visual Studio was installed with the following components:
- C++ ATL for latest v143 build tools
- Security Issue Analysis
- C++ Build Insights
- Just-In-Time debugger
- C++ profiling tools
- C++ CMake tools for Windows
- Test Adapter for Boost.Test 
- Test Adapter for Google Test
- Live Share
- IntelliCode
- C++ AddressSanitizer
- Windows 11 SDK
- vcpkg package manager

The hardwae used was a Intel(R) Core(TM) i7-10510U CPU with 16 gigabytes of system memory.

#figure(
  image("images/screenshot_build_options_windows.png", width: 100%),
  caption: [
    screenshot showing build settings in CLion on Windows
  ],
)

=== Linux

The project was built using ninja and gcc12.
Tests with the language server were performed using VSCodium @VSCodium, a fork of VS Code without telemetry. \

The hardware used was a AMD Ryzen™ PRO 4750U (8 core mobile) and a AMD Ryzen™ 9 5900X (12 core desktop) CPU with 48 gigabytes of system memory.

= Project Management
// - Vorgehen (Prozess, Reviews, Workflows, Qualitätssicherung)
// - Projektplan, Vergleich ursprüngliche Planung, effektive Ausführung
// - Zeiterfassung (Stunden pro Woche/Stunden pro Task-Kategorie, wie Implementation Doku, Meeting, etc.)
// Hinweis: Keine Liniendiagramme für die Darstellung von Zeit/Arbeitsaufwand pro Woche

== Methods
Development work occurred on both Linux and Windows utilizing CLion with the Ninja build system.
The language server features were tested using Visual Studio Code and the clangd extension.

#set page(flipped: true)

== Project Plan
Due to the absence of detailed guidelines, we can only offer a rough plan at this time.

#figure(
  box(
    width: 100%,
    tablex(
      header: 1,
      columns: (1fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr),
      align: center + horizon,
      map-rows: (row, cells) => cells.map(c =>
        if c == none {
          c
        } else {
          (..c, fill: if row == 0 { aqua })
        }
      ),
      /* --- header --- */
      [*w1*], [*w2*], [*w3*], [*w4*], [*w5*], [*w6*], [*w7*], [*w8*], [*w9*], [*w10*], [*w11*], [*w12*], [*w13*], [*w14*], [*w15*],
      /* ------------- */
      [Setup], colspanx(3)[1. refactoring feature], colspanx(2)[optimization & testing], colspanx(2)[contribute to LLVM], colspanx(3, fill:blue)[], colspanx(2)[finish documentation], [hand in], [Apéro],
      /* ------------- */
      colspanx(6)[], colspanx(5)[2. refactoring feature], colspanx(4)[]
    )
  ),
  caption: [ Project plan ],
)

#pagebreak()
#set page(flipped: false)

== Time Tracking
To monitor our working hours effectively, we have established a straightforward Google Sheet where we meticulously record information about our tasks, such as who is assigned to them, the task's nature, and the duration spent on each task. Additionally, each entry includes a brief comment detailing the specific work performed during that time.

// TODO small summary of time tracking

#set heading(numbering: none)

= Conclusion
// - Zusammenfassung
// - Evaluation der Ergebnisse
// - Zielerreichung/offene Punkte
// - Ausblick, weiterführende Schritte

= Outlook

= Learnings

= Personal Reports

= Disclaimer
Parts of this paper were rephrased by GPT-3.5.

= Glossary

/ AST: Abbreviation for Abstract Syntax Tree. \ The AST tree is a hierarchical representation of the code's structure, capturing the syntax and semantics of the code. 

/ LLVM: Abbreviation for Low Level Virtual Machine. \ A set of compiler and toolchain technologies.

/ SA: Abbreviation for Semester-Arbeit. \ The term is used in the German academic context to refer to a Semester Project.

#bibliography("bibliography.bib")

= Table of Figures
#outline(
  title: none,
  target: figure.where(kind: image),
)

= List of Listings
#outline(
  title: none,
  target: figure.where(kind: raw),
)

= Appendices

// - Relevante Anhänge
// - Meeting Protokolle
// - Vereinbarungen
// - (SA/BA): Persönliche Berichte (0.5-1 Seite)
// - Entwicklerdokumentation
// - User Dokumentation
// - Sonstige Protokolle (z.B. von Usability Tests)
