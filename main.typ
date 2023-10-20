#include "title-page.typ"
#import "@preview/tablex:0.0.4": tablex, colspanx, rowspanx, cellx

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

#set page(numbering: "1 / 1")

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
#link("https://github.com/llvm/llvm-project")[LLVM project] is an open source repository on GitHub and contains the source code for LLVM, a toolkit for the construction of highly optimized compilers, optimizers, and run-time environments. 

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

To fuilfill the project goal it is important to know what LLVM is and how it works. 
An image should help to understand the architecture:

#figure(
  image("images/llvm_architecture.jpeg", width: 80%),
  caption: [
    diagram showing architecture of LLVM,
    source: @LLVM_compiler_architecture
  ],
)

== The clangd Language Server

Clangd is the language server which lives in the #link("https://github.com/llvm/llvm-project")[llvm-project] repository under `clang-tools-extra/clangd`. For this project the goal is to add refactoring features which can be found within the clangd folder `tweaks`.

== Coding Guidelines

As all big projects the LLVM also has defined condign guidelines which should be followed.
The documentation is written really well and can be found #link("https://llvm.org/docs/CodingStandards.html")[here].
A lot of guidelines are written down but some things seem to be missing. 
While refactoring the first feature the question came up if trailing returns should be used or not.
Unfortunately this case is not described within the coding guidelines and after looking at other code snippets it was decided to stick with the non trailing version of return values.

=== Coding Formatter
To fulfill the formatting guidelines there is a formatter within the project which styles the files according to the guidelines.

To check ensure that the format is correct, a job is running on Github for Pull-Request.
The Pull-Request can only be merged if the job finishes successfully.

// TODO: add link

== Refactorings in clangd

=== Project Structure

The LLVM project is quite big and it took a while to figure out how it is structured.
For refactoring features classes can be created in the following directory:
- llvm-project
  - clang-tools-extra
    - clangd
      - refactor
        - tweaks

=== Existing Refactorings
Looking at the refactoring features no feature could be found which can be used on concepts.
As concepts were introduced with C++20 it is quite to the world of C++ and therefore not much of support exists yet.

For other scenarios multiple refactorings already exist e.g. switching statements within an if.
Looking at the existing refactoring code helped to understand the how a refactoring is done.

=== Testing
The LLVM project strictly adheres to a well-defined architecture for testing. To align with #link("https://clangd.llvm.org/design/code.html#testing")[project guidelines], automated unit tests must be authored prior to the acceptance of any code contributions.

Unit tests can be added within this directory:
- llvm-project
  - clang-tools-extra
    - clangd
      - unittests

#pagebreak()

=== Class Functions and Structure

// TODO: describe `prepare`
*```cpp prepare(const Selection &Inputs)```:* \
Within the `prepare` function it needs to be checked if a refactoring is possible on the selected area.

// TODO: decribe `apply` 
*```cpp apply(const Selection &Inputs)```:* \
Within the `apply` function the actual refactoring is taking place.


General class structure for refactoring features:
```cpp
namespace clang {
namespace clangd {
namespace {
/// Feature description
class <ClassName> : public Tweak {
public:
  const char *id() const final;

  bool prepare(const Selection &Inputs) override;
  Expected<Effect> apply(const Selection &Inputs) override;
  std::string title() const override { return "Refactoring Title"; }
  llvm::StringLiteral kind() const override {
    return CodeAction::REFACTOR_KIND;
  }
};

REGISTER_TWEAK(<ClassName>)

bool <ClassName>::prepare(const Selection &Inputs) {
  // Check if refactoring is possible
}

Expected<Tweak::Effect> <ClassName>::apply(const Selection &Inputs) {
  // Refactoring code
}

} // namespace
} // namespace clangd
} // namespace clang

```

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

== Concept Simplification

With shortcuts and terse syntax concepts can be simplified.

More details about the code simplification can be found here: #link("https://www.cppstories.com/2021/concepts-intro/#code-simplification").

Unconstrained `auto` can be used to replace `T`:

#figure(
  ```cpp
  template <typename T>
  void print(const std::vector<T>& vec) {
    for (size_t i = 0; auto& elem : vec)
        std::cout << elem << (++i == vec.size() ? "\n" : ", ");
  }
  ```, 
caption: [Example of a concept]
)

#figure(
  ```cpp
  void print2(const std::vector<auto>& vec) {
    for (size_t i = 0; auto& elem : vec)
        std::cout << elem << (++i == vec.size() ? "\n" : ", ");
  }
  ```,
caption: [Simplified concept]
)

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

= First Refactoring
For the first refactoring a subset of the initial idea (@first_idea) was implemented.
The following transformations are made possible by it.

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
  ),
  caption: "Capabilities of the first refactoring",
)

== Design
The refactoring will only hand simple cases for now.
This however can easily be expanded on in the future.
The restrictions for now are that only function templates are supported and conjunctions & disjunctions of concept requirements are not.

During the preparation phase the following elements need be captured.
They will be stored as a member of the tweak object and then used during the apply phase.

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

== Implementation
*Pull-Request:* https://github.com/llvm/llvm-project/pull/69693

== Testing

= Development Process

== Workflow

== Setup

== Git
To make life easier it was decided to create a repository on Github and make the whole work open source. 
As there was an already existing pipeline from the original llvm project it self the decision came rather quick as otherwise there could have popped up a lot of different problems and issues.

=== Windows

// TODO: Vina - add more text
Building LLVM:
+ Clone project from GitHub https://github.com/llvm/llvm-project
	- `git clone git@github.com:llvm/llvm-project.git`
+ open llvm projekt in Clion
+ Open folder `llvm/CMake.tx` in Clion and execute cmake
+ File -> Settings -> Build, Execution, Deployment -> CMake -> CMake options ->
	- add `-DLLVM_ENABLE_PROJECTS='clang;clang-tools-extra'`
+ Choose "cland" in target selector and start building

=== Linux

// TODO: Jeremy

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
#set heading(numbering: none)

== Time Tracking
To monitor our working hours effectively, we have established a straightforward Google Sheet where we meticulously record information about our tasks, such as who is assigned to them, the task's nature, and the duration spent on each task. Additionally, each entry includes a brief comment detailing the specific work performed during that time.

// TODO small summary of time tracking

= Conclusion
// - Zusammenfassung
// - Evaluation der Ergebnisse
// - Zielerreichung/offene Punkte
// - Ausblick, weiterführende Schritte

= Outlook

= Personal Reports

= Disclaimer
Parts of this paper were rephrased by GPT-3.5.

= Glossary
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
