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
The clangd sub project contains a few refactor operations, but none specific to C++20 concepts yet.

== Project Goal
The goal of this semester project is to come up with new ideas for refactor operations specific to concepts and to implement some of them.
Ideally they should be submitted upstream as a Pull Request.

// TODO where to place this? Is it needed?
= Structure of This Report
This report encompasses the analysis, elaboration, and implementation of the project's work. It is structured into the following sections:

// TODO descibe chapers