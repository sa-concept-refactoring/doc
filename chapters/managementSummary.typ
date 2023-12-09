// - Das Management Summary richtet sich in der Praxis an die "Chefs des Chefs", d.h. an die
// Vorgesetzten des Auftraggebers (diese sind in der Regel keine Fachspezialisten). Die Sprache
// soll knapp, klar und stark untergliedert sein. (Aus Anleitung Dokumentation FS21 vom SG-I)
// - Der Umfang beträgt in der Regel 3-5 Seiten.
// - Bilder sind hier sinnvoll

= Management Summary

The goal of this project was to add new refactorings to the clangd language server to support the use of concepts that were introduced with C++20.

Two new refactoring operations were implemented and the resulting patches have been submitted to the LLVM project.
As of #datetime(year: 2023, month: 12, day: 22).display("[day].[month].[year]"), the Pull-Requests opened to merge the implemented refactorings into the LLVM-Project are still open.

/ Abbreviate Function Template : #[
Replaces the defined function parameter type with the type `auto` and removes the template definition.

#figure(
  table(
    columns: (1fr, 1fr),
    align: horizon,
    [*Before*], [*After*],
    [
      ```cpp
      template <std::integral T>
      void foo(T param) {}
      ```
    ],
    [
      ```cpp
      void foo(std::integral auto param) {}
      ```
    ]
  ),
  caption: [ Example of "Abbreviate Function Template" refactoring ],
)
]

/ Inline Concept Requirement : #[
Inlines the defined requirements into the template definition.
#figure(
  table(
    columns: (1fr, 1fr),
    align: horizon,
    [*Before*], [*After*],
    ```cpp
    template <typename T>
    void foo(T) requires std::integral<T> {}
    ```,
    ```cpp
    template <std::integral T>
    void foo() {}
    ``` ,
  ),
  caption: [ Example of "Inline Concept Requirement" refactoring ],
)
]

The implemented refactoring features are added to the clangd language server in the `refactor/tweaks` directory.
@refactoring_contribution shows VSCode using the clangd language server to display refactorings in the code editor.
In the example in @refactoring_contribution VSCode is communicating with the language server using LSP. 
To use clangd in VSCode the extension "clangd" can be used.

#figure(
  image("../drawio/refactoring_contribution.drawio.png"),
  caption: [
    Diagram showing integration of implemented refactoring
  ],
) <refactoring_contribution>

#pagebreak()

/ Key findings : #[
- Parts of the code within the LLVM Project are quite old and use older language features. 
- Pull Requests often take a significant amount of time for reviewers to approve the changes.
- The clangd documentation is written really well and provides good support.
- Clangd contains functions which wre irritating and hard to understand and therefore leading to wrong conclusions.
]

/ Critical Issues and Challenges : #[
- Building clangd for the first time takes a lot of time and memory, and would have been good to know beforehand.
- JetBrains announced that they will stop using the clangd language server and implement language support themselves. @jetbrains_blog
- Finding out how to add reviewers to the Pull Request posed a considerable challenge due to the absence of explicit instructions.
  It appeared that the automated system malfunctioned, failing to allocate reviewers as intended.
]

/ Conclusions : #[
Language servers offer an effective method to extend language support across multiple IDEs.
The presence of an open-source project such as LLVM is not only a commendable initiative but also receives widespread appreciation among developers in the community.
Conversely, this circumstance contributes to a slower integration of new changes, given that a majority of contributors are engaged in the project during their leisure hours, impacting the pace of development.

One of the Pull Requests got a review from fellow contributor, who expressed anticipation for the integration of the refactoring in clangd, highlighting its potential usefulness. 
This comment serves as a promising conclusion to the project's development, and it is hoped that others will similarly perceive this addition as beneficial to the language server.
]
