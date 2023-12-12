// - Zusammenfassung
// - Evaluation der Ergebnisse
// - Zielerreichung/offene Punkte
// - Ausblick, weiterführende Schritte

= Conclusion <conclusion>
To summarize this thesis a conclusion describes the most important parts of the project.
@learnings looks into what was learned working on this thesis. 
In @outlook it is described how this project could be extended and what the future of the language server looks like.

This thesis, it was analyzed how the clangd language server works and how additional refactoring features can be added.
Two new refactoring features were implemented according to the analysis and were submitted to LLVM (pull requests are opened).

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

Unfortunately, the opened pull requests were not merged until this thesis was handed in therefore the added refactorings are not yet available in the current version of clangd.

== Learnings <learnings>
Overall this project was very interesting and enriched working on an open source project like LLVM.

For future projects, it should be considered to spend more time with the analysis part and look more into possible function structures and function types.
During the implementations, some cases came up which were not considered in the first place which then took some time to think about and evaluate.

Also, the documentation part of this project was underestimated a lot and it would have been good to start documenting the analysis part in the beginning.
Finding a good structure for the documentation was hard and it was changed many times.

== Outlook <outlook>
The content of this project could have been extended a lot more as there are almost unlimited options to add new refactorings.
As long as the C++ language is evolving more refactorings can be added to help support the developers.
In the case of this thesis, an option would have been possible to switch between different forms of concepts.
That feature could have connected the two refactoring implemented but this also would have taken way longer than it already did.

The LLVM project is an active open source project that receives a lot of pull requests each day.
This is giving hope, that it will continue to grow in the future.

Hopefully, the open pull requests will be accepted so the new refactorings will be available on the clangd language server.
But it remains unclear if the usage of language servers will increase or if IDEs are going back to implementing their own code support as JetBrains has already announced that they might.
