= Abstract <abstract>
// Introduction
With C++20 concepts were introduced which allow restricting template parameter types.
The objective of this project was to find novel refactoring operations related to concepts and to implement them as part of a language server.

// Methods
An analysis has been performed on the langage server protocol, the clangd language server and C++ concepts.
This resulted in a few potential refactoring operations,
two of which have been implemented as a tweak in the clangd language server.
Testing was performed manually using a test project and automated using unit tests.

The first implemented refactoring enables inlining _require_ clauses into the template declaration.
// TODO: Details?

The second implemented refactoring allows converting explicit template declarations to their abbreviated version using _auto_ parameters.
// TODO: Details?

// Results
The two implemented operations have been submitted upstream as a Pull-Request to the llvm repository and as of the writing of this paper (#datetime.today().display("[month repr:long] [year]")) are awaiting review.

// Discussion
Due to the limited amount of time available some features were left out.
They could be implemented as a follow-up.


// TODO

// Der Abstract richtet sich an den Spezialisten auf dem entsprechenden Gebiet und beschreibt
// daher in erster Linie die (neuen, eigenen) Ergebnisse und Resultate der Arbeit. (Aus
// Anleitung Dokumentation FS21 vom SG-I).
// - Der Umfang beträgt in der Regel eine halbe Seite Text
// - Keine Bilder
