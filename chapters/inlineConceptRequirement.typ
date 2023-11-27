#import "@preview/tablex:0.0.4": tablex, colspanx, rowspanx, cellx, hlinex

= Refactoring — Inline Concept Requirement <inline_concept_requirement>
For the first refactoring a subset of the initial idea (@first_idea) should be implemented.
Specifically the inlining of an explicit ```cpp requires``` clause into a constrained function template.
@capabilities_of_first_refactoring shows some examples of what this refactoring is able to do.

Limitations of the refactoring are discussed in @limitations_of_first_refactoring.

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
    template <typename T>
    void f() requires std::integral<T> {}
    ```,
    ```cpp
    template <std::integral T> 
    void f() {}
    ```,
  ),
  caption: "Capabilities of the first refactoring",
) <capabilities_of_first_refactoring>

#pagebreak()
== Analysis
For our analysis we looked at which elements need to be captured (@first_refactoring_captured_elements) and how the AST looks before and after the refactoring (@first_refactoring_ast_analysis).

=== Captured Elements <first_refactoring_captured_elements>
@first_refactoring_captured_elements_figure shows the captured elements and their purpose.
A reference to them is stored as a member of the tweak object during the preparation phase and used during the application phase.

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
  caption: "Elements captured for the \"Inline Concept Requirement\" refactoring",
) <first_refactoring_captured_elements_figure>

#pagebreak()
=== Abstract Syntax Tree <first_refactoring_ast_analysis>
The AST gives a good overview over the structure of the code before and after the refactoring.
In @first_refactoring_ast the AST trees of a simple template method and its corresponding refactored version are shown.

Looking at the original version (on the left) it is visible that the outermost `FunctionTemplate` contains the template type parameters, as well as the function definition.
The `requires` clause is represented by a `ConceptSpecialization` with a corresponding `Concept reference`.

During the refactor operation most of the AST stays untouched, except for the concept reference (in yellow), which gets moved to the template type parameter and the concept specialization, which gets removed (in red).

After looking at this we came to the conclusion that we can look out for `ConceptSpecialization` nodes to determine if the refactoring applies and then do further analysis.

#figure(
  tablex(
    columns: (200pt, 50pt, 200pt),
    align: center,
    auto-vlines: false,
    auto-hlines: false,
    [ *Before* ],
    [],
    [ *After* ],
    hlinex(),
    ```cpp
    template<typename T>
    void bar(T a) requires Foo<T> {
      a.abc();
    },
    ```,
    [],
    ```cpp
    template<Foo T>
    void bar(T a) {
      a.abc();
    }
    ```,
    hlinex(),
    colspanx(3)[#image("../images/ast_first_refactoring.png")],
  ),
  caption: "Example AST tranformation of first refactoring",
) <first_refactoring_ast>

#pagebreak()
== Implementation <first_refactoring_implementation>
The implementation itself was mostly straight-forward, that is once we figured out how to traverse the AST.
Discovery was made a bit hard by the fact that some methods we required were global and some required casting.
Looking at the existing refactorings helped a lot during this time. 

The biggest hurdle of this refactoring was the `requires` keyword itself,
which was quite hard to track down as it is not part of the AST itself.
To figure out where exaclty it is located in the source code it was necessary to resort to the token representation of the source range.

=== Pull Request
Our implementation has been submitted upstream as a Pull Request @pull_request_of_first_refactoring and as of #datetime.today().display("[month repr:long] [year]") is awaiting review.

#pagebreak()
== Limitations <limitations_of_first_refactoring>
To keep the scope of the implementation managable it was decided to leave some features out.
These limitations however could be lifted in a future version.
The implementation is built so it actively looks for these patterns and does not offer the refactoring operation if one is present.

=== Combined Concept Requirements
Handling combined require clauses would certainly be possible,
however it would increase the complexity of the refactoring code significantly.
Since working on the LLVM project is new for both of us we decided to leave it out for now.
#figure(
  ```cpp
  template <typename T, typename U>
  requires foo<T> && foo<U>
  void f(T)
  ```,
  caption: "Combined concept requirement",
)

=== Class Templates
Handling class templates would not have been a big stretch,
however the testing involved to make sure it works correctly would have taken a significant amount of time.
To keep the momentum going this was not implemented.
#figure(
  ```cpp
  template <typename T>
  requires foo<T>
  class Bar;
  ```,
  caption: "Class template",
)

=== Multiple Type Arguments
If a concept has multiple type arguments, such as ```cpp std::convertible_to<T, U>``` the refactoring will not be applicable.
#figure(
  ```cpp
  template <typename T>
  requires std::convertible_to<int, T>
  void f(T)
  ```,
  caption: "Function template with multiple type arguments",
)

#pagebreak()
== Testing

#set terms(
  hanging-indent: 0pt,
)

// TODO: Should we write a test protocol?
/ Manual: #[
  A lot of manual tests were performed using a test project.
  Debug inspections were also performed often to verify assumptions.
]

/ Automated: #[
  To test the implementation unit tests were written as described in @testing. 
  A total of 11 tests were written, 4 of them availability tests, 4 unavailability tests and 3 application tests.
  This is a similar extent to which existing refactorings are tested.
]

#pagebreak()
== Usage
The refactoring is available as a code action to language server clients.
// TODO: document where the refactoring option is available when right clicking

=== VS Code
To use the feature the user needs to hover over the requires clause e.g. `std::integral<T>`.
Then right click to show the code options. 
To see the possible refactorings the option "Refactoring" needs to be clicked and then the newly added feature "Inline concept requirement" will appear within the listed options.

#figure(
  image("../images/screenshot_inline_concept.png", width: 50%),
  caption: [
    Screenshot showing the option to inline a concept requirement
  ],
)

=== Vim
@first_refactoring_usage_in_vim shows how the refactoring looks like before accepting it in Neovim.

#figure(
  image("../images/first_refactoring_usage_in_vim.png", width: 80%),
  caption: [
    Screenshot showing the option to inline a concept requirement
  ],
) <first_refactoring_usage_in_vim>
