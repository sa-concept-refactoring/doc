= Conclusion <conclusion>
// - Zusammenfassung
// - Evaluation der Ergebnisse
// - Zielerreichung/offene Punkte
// - Ausblick, weiterführende Schritte

In this thesis, it was analyzed how the clangd language server works and how the additional refactoring features can be added.
Two new refactoring features were implemented according tho the analysis and were submitted to LLVM (pull requests are opened).

When first looking at the LLVM project it can be overwhelming at first but once it is clear how it is put together it is easy to get around with.

Two new refactoring features were implemented to be contributed to the clangd language server which should help C++ 20 developers to work with the concepts for which there was no refactoring beforehand.

/ Inline Concept Requirement : #[
  Transforms the concept containing a `requires` clause into a restricted function template.
  This transformation results in a less complex and shorter code.
]

/ Abbreviate Function Template : #[
  Transforms the function template to its abbreviated form.
  The template parameter types are replaced with the `auto` keyword where possible.
  This transformation results in less code as the `template` declaration will be removed.
]

Unfortunately the opened pull requests where not merged until this theses was handed in therefore the added refactorings are not yet available in the current version of clangd.


== Learnings

== Outlook

The LLVM project is an active open source project which receives a lot of pull requests each day.
This is giving hope, that it will continue to grow in the future.

Hopefully the open pull requests will be accepted so the new refactorings would be available on the clangd language server.
