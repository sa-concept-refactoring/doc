// - Zusammenfassung
// - Evaluation der Ergebnisse
// - Zielerreichung/offene Punkte
// - Ausblick, weiterführende Schritte

= Conclusion <conclusion>
To summarize this thesis this conclusion describes the most important parts of the project.
@learnings looks into what was learned working on this project. 
In @outlook it is described how this project could be extended and what the future of the language server looks like.

// COR Hier fällt die passive Form der Formulierungen besonders auf.
In this thesis, it was analyzed how the clangd language server works and how additional refactoring features can be added.

When first looking at the LLVM project it can be overwhelming at first but once it is clear how it is put together it is easy to get around with.

Two new refactoring features were implemented according to the analysis and were submitted to LLVM (pull requests are opened).
The intention for these implementation is to be contributed to the clangd language server which should help C++ 20 developers to work with the concepts for which there was no refactoring beforehand.

// COR Reflection on the state of the refactorings?
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

For future projects, it should be considered to spend more time on the analysis part.
The implementation was started before all the necessary research was done, resulting in some avoidable pitfalls and slowing down the development process.
Most of these cases came up during the second refactoring @abbreviate_function_template and were related to parameter types that were not considered, such as array types and function pointers.
Those issues could probable have been avoided, if more time were spent with analysing which parameter types exist and properly documenting them.

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
// COR I would doubt that for open-source projects.
But it remains unclear if the usage of language servers will increase or if IDEs are going back to implementing their own code support as JetBrains has already announced that they might. @jetbrains_blog
