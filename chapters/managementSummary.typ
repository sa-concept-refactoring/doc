// - Das Management Summary richtet sich in der Praxis an die "Chefs des Chefs", d.h. an die
// Vorgesetzten des Auftraggebers (diese sind in der Regel keine Fachspezialisten). Die Sprache
// soll knapp, klar und stark untergliedert sein. (Aus Anleitung Dokumentation FS21 vom SG-I)
// - Der Umfang beträgt in der Regel 3-5 Seiten.
// - Bilder sind hier sinnvoll

= Management Summary

The goal of this project was to add new refactorings to the clangd language server to support the use of concepts, which were introduced with C++20.

Two new refactoring operations were implemented and the resulting patches have been submitted to the LLVM project.
As of #datetime(year: 2023, month: 12, day: 22).display("[month repr:long] [year]"), the pull requests opened to merge the implemented refactorings into the LLVM project are awaiting review.

/ Inline Concept Requirement : #[
Inlines type requirements from _requires_ clauses into the template definition, eliminating the _requires_ clause.
An example of its capabilities is shown in @management_summary_inline.
]

/ Abbreviate Function Template : #[
Eliminates the template declaration by using `auto` parameters.
An example of its capabilities is shown in @management_summary_abbreviate.
]

The refactoring operations were implemented as part of the clangd language server.
@refactoring_contribution shows a diagram of how VS Code is using the clangd language server to display refactoring operations.
It is communicating with the language server using the language server protocol, for which the "clangd" extension can be used. 

#figure(
  table(
    columns: (1fr, 1fr),
    align: horizon,
    [
      #set text(size: 0.9em)
      *Before*
    ],
    [
      #set text(size: 0.9em)
      *After*
    ],
    [
      #set text(size: 0.9em)
      ```cpp
      template <typename T>
      void foo(T) requires std::integral<T> {}
      ```
    ],
    [
      #set text(size: 0.9em)
      ```cpp
      template <std::integral T>
      void foo() {}
      ```
    ]
  ),
  caption: [ Example of "Inline Concept Requirement" refactoring ],
) <management_summary_inline>

#figure(
  table(
    columns: (1fr, 1fr),
    align: horizon,
    [
      #set text(size: 0.9em)
      *Before*
    ],
    [
      #set text(size: 0.9em)
      *After*
    ],
    [
      #set text(size: 0.9em)
      ```cpp
      template <std::integral T>
      void foo(T param) {}
      ```
    ],
    [
      #set text(size: 0.9em)
      ```cpp
      void foo(std::integral auto param) {}
      ```
    ]
  ),
  caption: [ Example of "Abbreviate Function Template" refactoring ],
) <management_summary_abbreviate>

#figure(
  image("../drawio/refactoring_contribution.drawio.png"),
  caption: [
    Diagram showing integration of implemented refactoring
  ],
) <refactoring_contribution>

#pagebreak()
#set heading(numbering: none)

=== Key Findings
- The clangd documentation is written really well and provides good support.
- Parts of the code within the LLVM project are quite old and use older language features. 
- Pull requests often take a significant amount of time for reviewers to approve or even review.
- Clangd contains functions which were irritating and hard to understand and therefore leading to wrong conclusions.

=== Critical Issues and Challenges
- Building clangd for the first time takes a lot of cpu time and memory.
  This resulted in initial builds taking multiple hours.
- Finding out how to add reviewers to the pull requests posed a considerable challenge due to the absence of instructions.
  It appeared that the automated system malfunctioned, failing to allocate reviewers as intended.

=== Conclusions
Language servers offer an effective method to provide language support across multiple IDEs.
The presence of an open-source project such as LLVM is not only a commendable initiative, but also receives widespread appreciation among developers in the community.
Conversely, this circumstance contributes to a slower integration of new changes, given that a majority of contributors are engaged in the project during their leisure hours, impacting the pace of development.

One of the pull requests got a review from fellow contributor, who expressed anticipation for the integration of the refactoring in clangd, highlighting its potential usefulness. 
Their comment serves as a promising conclusion to the project's development, and it is hoped that others will similarly perceive this addition as beneficial to the language server.
