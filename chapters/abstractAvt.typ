== Introduction
With C++20 template parameter constraints were introduced that allow to specify the expected functionality of template parameters.
The objective of this project was to add new refactoring operations to the clangd language server to support the use of template parameter constraints.

== Result
Two new refactoring operations were implemented and the resulting patches have been submitted to the LLVM project. As of December 2023, the pull requests opened to merge the implemented refactoring operations into the LLVM project are awaiting review.

Once approved they will become available to all development tools using clangd, including VS Code, NeoVim and Jetbrains CLion.

The first refactoring, "Inline Concept Requirement", inlines type requirements from requires clauses into the template deﬁnition, thus eliminating the requires clause.

The second refactoring, "Abbreviate Function Template", eliminates the template declaration by using the auto keyword for the parameters types.


== Conclusion
Language servers oﬀer an eﬀective method to provide language support across multiple IDEs.
The presence of an open-source project such as clangd is not only a commendable initiative, but also receives widespread appreciation among developers in the community. Conversely, this circumstance contributes to a slower integration of new changes, given that a majority of contributors are engaged in the project during their leisure hours, impacting the pace of development.


// Bemerkungen der Examinatoren:
// Mir gefällt die Introduction und das Result gut. Diese Teile kann man so lassen. Die Conclusion ist eine allgemeine Beschreibung von Language-Servern. Das nichts mit eurer Arbet zu tun. Mein Vorschlag: 
// - Schiebt das Result nach rechts (Conclusion löschen)
// - Fügt eine Task-Section ein mit der Aufgabenstellung.
// - Allenfalls Result anpassen, dass es keine Duplikation gibt.
// - Bei Bedarf Introduction erweitern (Einen Satz zu Language-Server).


== Introduction
With C++20 template parameter constraints were introduced that allow to specify the expected functionality of template parameters.
The objective of this project was to add new refactoring operations to the clangd language server to support the use of template parameter constraints.
Language servers oﬀer an eﬀective method to provide language support across multiple IDEs.

With C++20 template parameter constraints were introduced that allow to specify the expected functionality of template parameters. Clangd is a language server that is part of the open source project LLVM. It provides features like refactorings among other things. These features are not supporting template parameter constraints as of December 2023.

== Definition of Task
The goal of this project was to analyze if common refactoring features can be applied to concepts or if some already exist. New refactoring features should be implemented to support the use of concepts. Ideally, the new refactorings are submitted upstream as a pull request to clangd to support the C++ community as well as helping the LLVM project grow.

The aim of this project was to analyze whether common refactoring features can be applied to concepts or if any such features already exist.
New refactoring features should be implemented to support the use of template parameter constraints. Ideally, the new refactorings are submitted upstream to clangd to support the C++ community as well as helping the clangd langauge server grow.

== Result
Two new refactoring operations were implemented and the resulting patches have been submitted to the LLVM project. As of December 2023, the pull requests opened to merge the implemented refactoring operations into the LLVM project are awaiting review.

Once approved they will become available to all development tools using clangd, including VS Code, NeoVim and Jetbrains CLion.

The first refactoring, "Inline Concept Requirement", inlines type requirements from requires clauses into the template deﬁnition, thus eliminating the requires clause.

The second refactoring, "Abbreviate Function Template", eliminates the template declaration by using the auto keyword for the parameters types.