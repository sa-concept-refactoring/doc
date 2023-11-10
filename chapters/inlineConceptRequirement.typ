#import "@preview/tablex:0.0.4": tablex, colspanx, rowspanx, cellx

= Refactoring — Inline Concept Requirement <inline_concept_requirement>
For the first refactoring a subset of the initial idea (@first_idea) was implemented.
The resulting patch has also been submitted upstream as a pull request on GitHub @pull_request_of_first_refactoring.

Only simple cases are handled for now, however the functionality could easily be expanded upon in the future.
The restrictions for now are that only function templates are supported and conjunctions & disjunctions of concept requirements are not.

Some examples of what this refactoring can do as of now can be found in the table below.

#figure(
  table(
    columns: (1fr, 1fr),
    align: horizon,
    [*Before*], [*After*],
    ```cpp
    template <typename T>
      void f(T) requires foo<T> {}
    ```,
    ```cpp
    template <foo T>
    void f(T) {}
    ``` ,
    ```cpp
    template <typename T>
    requires foo<T>
    void f(T)
    ```,
    ```cpp
    template <foo T>
    void f(T) {}
    ```,
    ```cpp
    template <template <typename> class Foo, typename T>
    void f() requires std::integral<T> {}
    ```,
    ```cpp
    template <template <typename> class Foo, std::integral T> 
    void f() {}
    ```,
  ),
  caption: "Capabilities of the first refactoring",
)

== Testing

// TODO: add tests to appendix
To test the implementation unit tests were written as described in @testing. \
There are a total of 11 tests, which consist of the following:
- 4 availability tests
- 4 unavailability tests
- 3 application tests

#pagebreak()
== Implementation

=== Captured Elements
During the preparation phase the following elements need be captured.
They will be stored as a member of the tweak object and then used during the application phase.

#figure(
  tablex(
    columns: 2,
    auto-vlines: false,
    ```cpp
    template <typename T>
              ^^^^^^^^^^
    void f(T) requires foo<T> {}
    ```,
    [
      *Template Type Parameter Declaration* \
      Will be updated using the concept found in the concept specialization expression below.
    ],
    ```cpp
    template <typename T>
    void f(T) requires foo<T> {}
                       ^^^^^^
    ```,
    [
      *Concept Specialization Expression* \
      Will be removed.
    ],
    ```cpp
    template <typename T>
    void f(T) requires foo<T> {}
              ^^^^^^^^
    ```,
    [
      *Requires Token* \
      Will be removed.
    ],
  ),
  caption: "Elements captured for the first refactoring",
)

=== Function Prerequisite
The refactoring should be as defensive as possible and only apply when it is clear that it will apply correctly. The following checks are made during the preparation phase to ensure this.

#figure(
  table(
    columns: (1fr, 1.5fr),
    align: start,
    [*Check*], [*Reasoning*],
    [
      The selected ```cpp requires``` clause only contain a single requirement.
    ],
    [
      Combined concept requirements are complex to handle and would increase the complexity drastically.
    ],
    [
      The selected concept requirement only contain a single type argument.
    ],
    [
      With multiple type arguments inlining would not be possible.
    ],
    [
      The concept requirement has a parent of either a function or a function template.
    ],
    [
      To restrict the refactoring to function templates only.
      This is a temporary restriction that could be lifted in the future.
    ],
  ),
  caption: "Checks made during the first refactoring",
)

#pagebreak()

=== AST Analysis

To get to know the structure of the code which needs to be refactored, the AST tree gives a good overview.

On the left the AST tree is shown of the code on the right:


#figure(
  table(
    columns: (1fr, 1fr),
    align: center,
    stroke: none,
    [*AST*], [*Code*],
    image("../images/screenshot_ast_first_refactoring.png", width: 80%),
    [
      ```cpp
      template<typename T>
      void bar(T a) requires Foo<T> {
        a.abc();
      }
      ```
    ],
  ),
  caption: [
    AST analysis of second refactoring
  ]
)

== Usage
// TODO: document where the refactoring option is available when right clicking

==== VS Code
To use the feature the user needs to hover over the requires clause e.g. `std::integral<T>`.
Then right click to show the code options. 
To see the possible refactorings the option "Refactoring" needs to be clicked and then the newly added feature "Inline concept requirement" will appear within the listed options.

#figure(
  image("../images/screenshot_inline_concept.png", width: 50%),
  caption: [
    screenshot showing the option to inline the concept requirement
  ],
)
