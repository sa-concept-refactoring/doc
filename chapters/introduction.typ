= Introduction

// - Beschreibung der Ausgangslage
// - Beschreibung der Aufgabe
// - Rahmenbedingungen
// - Vorarbeiten
// - Übersicht über die kommende Kapitel

== Initial Situation

The programming language C++ is constantly developed further by the standard committee @cpp_standard_committee. 
With C++20 type constraints were introduced which allow specification of requirements for template arguments.
Concepts are a way of abstracting these constraints. @constraints_and_concepts

Refactoring is a common technique to detect code smells and improve the internal structure of code without changing its external behavior. @refactoring
Automated tests often ensure that the correct functionality is retained.

Older versions of integrated development environments (IDE) were implementing support for code analysis and tools like symbol lookup and refactorings themselves.
This led to the problem that new languages only slowly gained adoption, one editor at a time.
The goal of the Language Server Protocol was to address this and have the compiler or an adjacent tool implement the logic of these IDE features independently of a specific editor in something called a Language Server.
Editors then only need to know how to communicate with this Server and they gain support for a wide range of languages.

The new constructs of C++20 concepts provide the potential to apply established refactorings, and there is also the possibility of developing new refactorings.

The LLVM project @llvm_github is an open source project, whose source code is available on GitHub.
It contains the source code for LLVM, a toolkit for the construction of highly optimized compilers, optimizers, and run-time environments. 

Clangd is a language server which lives within the LLVM project. 
It understands the C++ code and contains smart features like code completion, compile errors and go-to-definitions.

== Problem Description
When coding in C++ features like code refactorings are a very helpful tool.
They can help detect bad code or can help to optimize it.
To make these features available to all IDEs the language server clangd can be used.

Unfortunately not many refactorings are available, especially not for C++20.
Therefore it would be nice to have some support for new language features like concepts.
It would make coding much more convenient and make the developer aware of other ways of writing code using the newly added features.

== Project Goal
The goal of this semester project is to come up with new ideas for refactor operations specific to concepts and to implement some of them.
Ideally they should be submitted upstream as a pull request.
