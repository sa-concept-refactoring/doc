// - Beschreibung der Ausgangslage
// - Beschreibung der Aufgabe
// - Rahmenbedingungen
// - Vorarbeiten
// - Übersicht über die kommende Kapitel

= Introduction

// COR Not to dissuade, but the intro would be slightly more compelling if there was a refactoring (idea) that supported the transformation from <C++20 code to constrained code/concepts.

Writing clean and readable code is getting more important as programming languages are growing and evolving.
This is also the case for C++, therefore, refactoring already written code is becoming more important.

#set quote(block: true)

#quote(attribution: [Dori Exterman @tips_for_cpp_refactoring])[Aside from the problems that could affect any language, C++ developers find code refactoring more challenging, in part because the language is complex. This complexity is compounded with language-extending functionality such as macros and templates, not to mention that the language is large, to begin with, and the syntax is difficult to process.]

The task of the project involves implementing and contributing new refactoring features to the LLVM project in order to assist the C++ community with their refactoring tasks.

== Initial Situation

The C++ programming language is constantly developed further by the standard committee @cpp_standard_committee. 
With C++20, template parameter constraints were introduced which allow specification of requirements for template arguments.
Concepts are a way of abstracting these constraints. @constraints_and_concepts

Refactoring is a common technique to resolve code smells and improve the internal structure of code without changing its external behavior. @refactoring
Automated tests often ensure that the correct functionality is retained.

Older versions of integrated development environments (IDEs) were implementing support for code analysis and tools like symbol lookup and refactorings themselves.
This led to the problem that new languages only slowly gained adoption, one editor at a time, each of them having to spend the effort to implement support for it.
The goal of the Language Server Protocol was to address this and have the compiler or an adjacent tool implement the logic of these IDE features independently of a specific editor in something called a Language Server.
Editors then only need to know how to communicate with this Server and they gain support for a wide range of languages. @lsp_bit_services

The new constructs of C++20 concepts provide the potential to apply established refactorings, and there is also the possibility of developing new refactorings.
The LLVM project @llvm_github is an open source project, whose source code is available on GitHub.
It contains the source code for LLVM, a toolkit for the construction of highly optimized compilers, optimizers, and run-time environments. 
Clangd is a language server which lives within the LLVM project. 
It is able to recognize and make use of C⁠+⁠+ code and contains smart features like code completion, compile errors and go-to-definitions.

#pagebreak()
== Problem Description
When developing in any programming language features like code refactorings are a helpful tool.
They can help to restructure and simplify source code.
To make these features available to as many IDEs as possible the language server protocol can be used.

One language server for C++ is clangd, which unfortunately does not have many refactorings available, especially not for features introduced with C++20.
Therefore, it would be nice to have some support for new language features like concepts.
It would make development much more convenient and make the developer aware of other ways of writing code using the newly added features.

== Project Goal
This section describes the goals of this project according to the task assignment @assignment.
Additionally, parts were added to give the project more structure, as this project is more explorative than usual.

The goal of this semester thesis is to come up with new ideas for refactoring operations specific to parameter type constraints and to implement some of them.
It should be checked if currently existing refactorings can be applied to concepts.
This may already be implemented in the currently available tooling.
Ideally, new refactorings should be submitted upstream as a pull request to clangd.
This is done to support the C++ community as well as helping the LLVM project grow.

In addition to this, research will also be carried out to determine how the clangd language server is communicating with the development tools.
This also includes documenting the basic knowledge needed to understand it.

For the implementation itself, it needs to be clear where the code needs to be added, how it should be tested, what the coding guidelines are, and how it can be contributed.
Each implemented refactoring feature should be documented, including is usage and how it transforms the source code. 

#pagebreak()
== Structure of This Report
This report encompasses the analysis, elaboration, and implementation of the project's work. It is structured into the following sections:

*@analysis:* Captures the findings from the research conducted on the foundational principles of the language server protocol and clangd in particular.

*@refactoring_ideas:* Lists the collected ideas for potential refactorings.

*@inline_concept_requirement:* Describes the implementation process and result of the refactoring "Inline Concept Requirement".

*@abbreviate_function_template:* Describes the implementation process and result of the refactoring "Convert Function Template to Abbreviated Form".

*@development_process:* Gives insight about how the development environment was set up and which steps were needed to make the LLVM project compile locally.

*@project_management:* Outlines how the project was approached and explains the project plan and time tracking.

*@conclusion:* Summarizes key findings, insights, and implication of the project.
