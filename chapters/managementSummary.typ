= Management Summary

// - Das Management Summary richtet sich in der Praxis an die "Chefs des Chefs", d.h. an die
// Vorgesetzten des Auftraggebers (diese sind in der Regel keine Fachspezialisten). Die Sprache
// soll knapp, klar und stark untergliedert sein. (Aus Anleitung Dokumentation FS21 vom SG-I)
// - Der Umfang beträgt in der Regel 3-5 Seiten.
// - Bilder sind hier sinnvoll

The goal of this project was to add new refactorings to the clangd language server to support the use of concepts which were introduced with C++20.

For this, two new refactorings were implemented to be contributed to the LLVM Project.
As of #datetime(year: 2023, month: 12, day: 22).display("[day].[month].[year]") the Pull-Requests opened to merge the implemented refactorings into the LLVM-Project are still open.

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
      void foo(auto param) {}
      ```
    ]
  ),
  caption: "Example of abbreviate function template refactoring",
)
]

/ Inline Concept Requirement : #[
Is inlining the defined requirements into the template definition.
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
  caption: "Example of inline concept requirement refactoring",
)
]

The implemented refactoring features are added to the clangd language server to the `refactor/tweaks` directory.
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

- Some code parts within the LLVM Project are quite old and using older language features. 
- Pull Request are often waiting a long time for reviewers to approve the changes.
- The clangd documentation is written really well and is a good support.
- Some functions are a bit confusing and lead to wrong conclusions.

]

/ Critical Issues and Challenges : #[

- Building clangd the first time takes a lot of time and memory and would have been good to know beforehand.
- JetBrains announced that they will stop using the clangd language server and implement language support themselves.
- Finding out how to add reviewers the Pull-Request was quite challenging as there was no mention of what to do. 
  Apparently the but wasn't working correctly and didn't assign the reviewers.

]

/ Conclusions : #[

Language servers are a good way to support language support for more than just one IDE. 
Having an open source project like LLVM is a really good idea and is also appreciated by a lot of developers.
On the other hand, it also makes the process of adding new changes quite slow as almost all participants are working on it during their free time.

One of the Pull-Request got a review from an other contributor who was writing that he is looking forward to the refactoring to be in clangd as it could be quite useful.
This comment seems to conclude the work of this project quite well and hopefully others will find it a good addition to the refactoring section as well.

]
