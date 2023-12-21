= Refactoring Ideas <refactoring_ideas>
// COR Per se wäre es wohl spannend gewesen alle Ideen zu beschreiben, auch wenn sie keine Refactorings sind oder nicht umsetzbar sind.
// Jeremy Did we have other ideas?
In this section ideas for potential refactoring operations are explored.
This serves as the foundation for deciding which features to implement.
A total of three ideas are described.

The concepts outlined in this section are intentionally presented in a basic state. 
The objective is to subject subsets of these concepts to further analysis and refinement for each refactoring operation during the implementation phase.

The first idea, described in @idea_requirement_transformation, is inspired by sample code from the constraints and concept reference @constraints_and_concepts.
The second idea, described in @idea_extraction, came up during experimentation with concepts.
Finally, the third idea (@concept-generation) describes automatic concept declaration generation.

== Requirement Transformation <idea_requirement_transformation>
A refactoring could be provided to transform a function template using constraints between alternate forms.
@transformation_idea_listing shows different variations of a function template.
They all result in an identical function signature after instantiation and thus cannot co-exist.
This was verified using gcc and clangd.

The benefit of this is in many cases a more readable function declaration.
For more readable code some developers prefer to remove unnecessary code like the `requires` keyword.
The versions on the left in @transformation_idea_listing shows how the code looks like without the keyword resulting in the same logic.
The potential refactoring would therefore focus on the removal of the `requires` clause.

This idea was inspired by the constraints and concept reference @constraints_and_concepts since it lists all these forms in its first code snippet.

#figure(
  kind: table,
  grid(
    columns: (auto, auto),
    gutter: 1em,
    align(start + horizon)[
      ```cpp
      template<Hashable T>
      void f(T) {}
      ```
    ],
    align(start + horizon)[
      ```cpp
      template<typename T>
      void f(T) requires Hashable<T> {}
      ```
    ],
    align(start + horizon)[
      ```cpp
      void f(Hashable auto x) {}
      ```
    ],
    align(start + horizon)[
      ```cpp
      template<typename T> requires Hashable<T>
      void f(T) {}
      ```
    ],
  ),
  caption: [Different ways to constrain a function template using concepts],
) <transformation_idea_listing>

#pagebreak()

== Extraction of Conjunctions and Disjunctions <idea_extraction>
Sometimes more than one constraint is used in a ```cpp requires``` clause.
This is expressed by `||` and `&&` operators.
The proposed refactoring would offer to extract these logical combinations into a new named concept.

One possible hurdle for this refactoring could be that there is no way to trigger a rename of the newly created concept.
This seems to be a limitation of the language server protocol @lsp_issue_724 @lsp_issue_764.
The refactoring itself would still be possible, but use a generated name for the new concept, requiring the user to rename it.

To illustrate the idea, @conjunction_idea_listing shows a method `bar` whose type parameter `T` is constrained by two concepts.
These requirements are extracted into a new named concept in @refactored_conjunction_idea_listing.
The name _NAME_ would be the name generated by the refactoring.

// COR How about (more complex) requires requires clauses?
#figure(
  ```cpp
  template <typename T>
  void bar(T a) requires std::integral<T> && Hashable<T> {
    ...
  }
  ```,
  caption: [An existing conjunction],
) <conjunction_idea_listing>

#figure(
  ```cpp
  template<typename T>
  concept NAME = std::integral<T> && Hashable<T>;

  template <typename T>
  void bar(T a) requires NAME<T> {
    ...
  }
  ```,
  caption: [The proposed refactoring to the conjunction in @conjunction_idea_listing],
) <refactored_conjunction_idea_listing>

#pagebreak()

== Concept Generation <concept-generation>
A refactoring that generates a new concept declaration based on an existing function template declaration would be really useful.
It would allow developers to write comprehensive concepts more easily without having to analyze their code in detail.

For example the function template in @concept_generation_function_example would result in a concept and function template declaration like the one in @concept_generation_concept when applied to the template parameter `T`.

#figure(
  ```cpp
  template <typename T>
  void foo(T a) {
    double x = a.abc();
  }
  ```,
  caption: "Simple function template declaration",
) <concept_generation_function_example>

#figure(
  ```cpp
  template<typename T>
  concept HasAbcMethod = requires(T a) {
    { a.abc() } -> std::convertible_to<double>;
  };

  template <HasAbcMethod T>
  void foo(T a) {
    double x = a.abc();
  }
  ```,
  caption: [@concept_generation_function_example with the concept extracted],
) <concept_generation_concept>
