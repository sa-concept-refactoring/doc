= Introduction

// - Beschreibung der Ausgangslage
// - Beschreibung der Aufgabe
// - Rahmenbedingungen
// - Vorarbeiten
// - Übersicht über die kommende Kapitel

== Initial Situation
The programming language C++ is constantly developed further by the standard committee @standard_committee. 
With the newest changes of C++ 20, type constraints were introduced with which the functionality of template parameters can be specified.
The so called "Concepts" allow to name predicates for template arguments.

Refactoring is a common technique to detect code smells and improve the internal structure of code in general without changing its external behavior.
Automated tests ensure that the correct functionality is maintained.

Older versions of integrated development environments (IDE) were implementing support for code analysis and tools like refactorings themselves.
Meanwhile these components are outsourced into separate software components.
Language Servers implement these kind of functionalities and provide small plug-ins which are communicating over the Language Server Protocol and can be integrated into any IDE.

The new constructs of C++20 concepts provide the potential to apply established refactorings, and there is also the possibility of developing new refactorings.

The LLVM project @llvm_github is an open source project, whose source code is available on GitHub.
It contains the source code for LLVM, a toolkit for the construction of highly optimized compilers, optimizers, and run-time environments. 

Clangd is a language server which lives within the LLVM project. 
It understands the C++ code and contains smart features like code completion, compile errors and go-to-definitions.

== Problem Description
When coding in C++ features like code refactorings are very helpful tool.
They can help detect bad code or can help to optimize it.
To make these features available to all IDEs the language server clangd can be used.

Unfortunately not many refactorings are available, especially not for the newest C++ 20 version.
Therefore it would be nice to have some support for new language features like concepts.
It would make coding much more convenient and make the developer aware of other ways of writing code using the newly added features.

== Project Goal
The goal of this semester project is to come up with new ideas for refactor operations specific to concepts and to implement some of them.
Ideally they should be submitted upstream as a Pull Request.

= Structure of This Report
This report encompasses the analysis, elaboration, and implementation of the project's work. It is structured into the following sections:

*@analysis:* Captures the findings from the research conducted on the foundational principles of the clangd Language Server.

*@refactoring_ideas:* Lists the collected ideas for a potential refactoring.

*@inline_concept_requirement:* Describes the implementation process and result of the refactoring "inline concept requirement".

*@convert_to_abbreviated_form:* Describes the implementation process and result of the refactoring "Convert to abbreviated form".

*@development_process:* Gives insight about how the development environment was set up and which steps were needed to make the llvm project compile locally.

*@conclusion:* Summarizes key findings, insights, and implication of the project.
