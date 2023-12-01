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
To use clangd in VSCode the extension "clangd" can be used.

#figure(
  image("../drawio/refactoring_contribution.drawio.png"),
  caption: [
    Diagram showing integration of implemented refactoring
  ],
) <refactoring_contribution>


/ Key findings : #[

Finding the correct functions to use could take a while but when they were found the refactorings would progress very quickly.

]
// Key findings and highlights
Implementing the refactorings was not always an easy task.

One of the implemented refactoring was finished quite early and a Pull-Request to merge the code into the LLVM Project was created.

// Critical Issues and Challenges
Building the project was quite a problem at first as this would take hours depending on the system used.
The first few times the build stopped or had some issues so it needed to build over again.
But after the first build was successful the adjustment of the codes where build quite quickly and the work could go on.



/ Conclusions : #[
Language servers are a good way to support language support for more than just one IDE. 
Having an open source project like LLVM is a really good idea and is also appreciated by a lot of developers.
On the other hand, it also makes the process of adding new changes quite slow as almost all participants are working on it during their free time.

]
