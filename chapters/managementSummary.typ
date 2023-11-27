= Management Summary

// - Das Management Summary richtet sich in der Praxis an die "Chefs des Chefs", d.h. an die
// Vorgesetzten des Auftraggebers (diese sind in der Regel keine Fachspezialisten). Die Sprache
// soll knapp, klar und stark untergliedert sein. (Aus Anleitung Dokumentation FS21 vom SG-I)
// - Der Umfang beträgt in der Regel 3-5 Seiten.
// - Bilder sind hier sinnvoll

The goal of this project was to add new refactorings to the clangd language server to support the use of concepts which were introduced with C++20.

For this, two new refactorings were implemented to be contributed to the LLVM Project.

/ Inline Concept Requirement : #[
Inlines the defined requirements into the template definition.
]

/ Abbreviate Function Template : #[
Replaces the defined function parameter type with the type `auto` and removes the template definition.
]

#figure(
  image("../drawio/refactoring_contribution.drawio.png"),
  caption: [
    Diagram showing integration of implemented refactoring
  ],
)


// Key findings and highlights
Implementing the refactorings was not always an easy task.
Finding the correct functions to use could take a while but when they were found the refactorings would progress very quickly.

One of the implemented refactoring was finished quite early and a Pull-Request to merge the code into the LLVM Project was created.
// TODO: note correct date
Unfortunately no member of the project has given any review of today.


// Critical Issues and Challenges
Building the project was quite a problem at first as this would take hours depending on the system used.
The first few times the build stopped or had some issues so it needed to build over again.
But after the first build was successful the adjustment of the codes where build quite quickly and the work could go on.



// Conclusion
