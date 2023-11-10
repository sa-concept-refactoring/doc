= Refactoring Ideas <refactoring_ideas>

== Requirement Transformation <first_idea>
A new refactoring could be provided to transform a function template using concepts between alternate forms.
@transformation_idea_listing shows the different forms.
They all result in an identical function signature.

#figure(
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

#pagebreak(weak: true)
== Extraction of Conjunctions and Disjunctions
Sometimes more than one constraint is used in a ```cpp requires``` clause.
This is expressed by `||` and `&&` operators.
The proposed refactoring would offer to extract these logical combinations into a new named concept.

One possible hurdle for this refactoring could be that there is no way to trigger a rename of this new concept.
This seems to be a limitation of the language server protocol @lsp_issue_724 @lsp_issue_764.

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
  template<class T>
  concept NAME = std::integral<T> && Hashable<T>;

  template <typename T>
  void bar(T a) requires NAME<T> {
    ...
  }
  ```,
  caption: [ The proposed refactoring to the conjunction in @conjunction_idea_listing ],
)

#pagebreak(weak: true)
== Abbreviation of Function Templates <third_idea>

Regular function templates could be converted to their abbreviated form, which uses auto parameters instead of explicit template arguments.

@abbreviation shows an example of a simple case with a concept constrained type parameter.
The resulting signature is identical to the original one.

This refactoring could potentially also be combined with the first idea (@first_idea) to directly convert a requires clause into an auto parameter (@combined_refactoring).

#figure(
  grid(
    columns: (auto, auto),
    gutter: 1em,
    align(start)[
      ```cpp
      template <std::integral T>
      auto f(T) -> void {}
      ```
    ],
    align(start + horizon)[
      ```cpp
      auto f(std::integral auto Tpl) -> void {}
      ```
    ]
  ),
  caption: [A function template and its abbreviated form]
) <abbreviation>

#figure(
  grid(
    columns: (auto, auto),
    gutter: 1em,
    align(start)[
      ```cpp
      template <typename T>
      requires concept<T>
      auto func(T param) { }
      ```
    ],
    align(start + horizon)[
      ```cpp
      auto func(concept auto param) { }
      ```
    ]
  ),
  caption: [A requires clause directly being converted to an abbreviated function template]
) <combined_refactoring>
