= Refactoring Ideas <refactoring_ideas>
In this section ideas for potential refactoring operations are explored.
This serves as the foundation for deciding which features to implement.
A total of two ideas will be explored.

The ideas presented here are intentionally in a very rough form.
The goal is that subsets of these will get analyzed further and refined for each refactoring operation.

The first idea, described in @idea_requirement_transformation, is inspired by sample code from the constraints and concept reference @constraints_and_concepts.
The second idea, described in @idea_extraction, did come up during experimentation with concepts.

== Requirement Transformation <idea_requirement_transformation>
A refactoring could be provided to transform a function template using constraints between alternate forms.
@transformation_idea_listing shows the different forms.
They all result in an identical function signature.

The benefit of this is in many cases a more readable function declaration.
In our opinion the `requires` clause just causes noise, so the versions on the left (@transformation_idea_listing) should be preferred.
The potential refactoring would therefore focus on the removal of the `requires` clause.

This idea was inspired by the constraints and concept reference @constraints_and_concepts,
since it lists all these forms in its first code snippet.

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
  caption: [
    Different ways to constrain a function template using concepts
  ],
) <transformation_idea_listing>

== Extraction of Conjunctions and Disjunctions <idea_extraction>
Sometimes more than one constraint is used in a ```cpp requires``` clause.
This is expressed by `||` and `&&` operators.
The proposed refactoring would offer to extract these logical combinations into a new named concept.

One possible hurdle for this refactoring could be that there is no way to trigger a rename of the newly created concept.
This seems to be a limitation of the language server protocol @lsp_issue_724 @lsp_issue_764.

To illustrate: @conjunction_idea_listing shows a method `bar` whose type parameter `T` is constrained by two concepts.
These requirements are extracted into a new named concept in @refactored_conjunction_idea_listing.

#figure(
  ```cpp
  template <typename T>
  void bar(T a) requires std::integral<T> && Hashable<T> {
    ...
  }
  ```,
  caption: [ An existing conjunction ],
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
  caption: [ The proposed refactoring to the conjunction in @conjunction_idea_listing ],
) <refactored_conjunction_idea_listing>
