#import "@preview/tablex:0.0.4": tablex, colspanx, rowspanx, cellx, hlinex

#let refactoring_name = "Inline Concept Requirement"

= Refactoring — #refactoring_name <inline_concept_requirement>
For this refactoring a subset of the initial idea (@idea_requirement_transformation) is implemented.
Specifically the inlining of an explicit ```cpp requires``` clause into a constrained function template.
@capabilities_of_first_refactoring shows some examples of what this refactoring is able to do.

A detailed analysis can be found in @first_refactoring_analysis.
Implementation details are discussed in @first_refactoring_implementation
and limitations are explored in @limitations_of_first_refactoring.
Finally, the usage of the refactoring is shown in @first_refactoring_usage.

#figure(
  table(
    columns: (1fr, 1fr),
    align: horizon,
    [*Before*], [*After*],
    ```cpp
    template <typename T>
    void f(T) requires foo<T>
    ```,
    ```cpp
    template <foo T>
    void f(T)
    ``` ,
    ```cpp
    template <typename T>
    requires foo<T>
    void f(T) 
    ```,
    ```cpp
    template <foo T>
    void f(T)
    ```,
    ```cpp
    template <typename T>
    void f() requires std::integral<T>
    ```,
    ```cpp
    template <std::integral T> 
    void f()
    ```,
  ),
  caption: [ Capabilities of the "#refactoring_name" refactoring ],
) <capabilities_of_first_refactoring>

#pagebreak()
== Analysis <first_refactoring_analysis>
// COR Preconditions? => Vina: Find au schad das mer die usegrüert hend, ich find s isch ned s gliiche wie d limitations
// COR [captured] Was bedeutet "captured"?
The analysis will look at which elements need to be captured (@first_refactoring_captured_elements) and how the refactoring transforms the AST (@first_refactoring_ast_analysis).

=== Captured Elements <first_refactoring_captured_elements>
@first_refactoring_captured_elements_figure shows the captured elements and their purpose.
A reference to them is stored as a member of the tweak object during the preparation phase and used during the application phase.

// COR st die Lifetime garantiert von einem Schritt zu anderen? Sprich ist es sicher derselbe AST?
// COR Diese Info ist eigentlich mehr Implementation als Analyse.

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
  caption: [ Elements captured for the "#refactoring_name" refactoring ],
) <first_refactoring_captured_elements_figure>

#pagebreak()
=== Abstract Syntax Tree <first_refactoring_ast_analysis>
The AST gives a good overview over the structure of the code before and after the refactoring.
In @first_refactoring_ast the ASTs of a simple template method and its corresponding refactored version are shown.

Looking at the original version (on the left) it is visible that the outermost `FunctionTemplate` contains the template type parameters, as well as the function definition.
The `requires` clause is represented by a `ConceptSpecialization` with a corresponding `Concept reference`.

During the refactor operation most of the AST stays untouched, except for the concept reference (in yellow), which gets moved to the template type parameter and the concept specialization, which gets removed (in red).

After the examination, it was concluded that `ConceptSpecialization` nodes can be searched to see if the refactoring applies, and then additional analysis can be performed.

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
  caption: [ Example AST tranformation of the "#refactoring_name" refactoring ],
) <first_refactoring_ast>

#pagebreak()
== Implementation <first_refactoring_implementation>
// COR [how to traverse the AST] Wie funktioniert das? Clang-AST Analyse?
The implementation process was relatively straightforward, particularly after determining how to traverse the AST.
// COR Sehr allgemein beschrieben. Allenfalls wären die Typhierarchien der Knoten noch spannend.
However, there were challenges in discovering certain methods, as some were global and others necessitated casting.
During this phase, referencing existing refactorings provided significant assistance.

// COR Hier könnte eine Grafik helfen, mit den relevanten Tokens und den zugehörigen AST-Knoten.
The biggest hurdle of this refactoring was the `requires` keyword itself,
which was quite hard to track down as it is not part of the AST itself.
To figure out where exactly it is located in the source code it was necessary to resort to the token representation of the source range.

#[
  #set heading(numbering: none)

  === Testing
  A lot of manual tests were performed using a test project.
  Debug inspections were performed often to verify assumptions.
  Unit tests were also written as described in @testing, which consist of a total of 11 tests, 4 of them availability tests, 4 unavailability tests and 3 application tests.
  This is a similar extent to which existing refactorings are tested.

  === Pull Request
  The implementation has been submitted upstream as a pull request @pull_request_of_first_refactoring and as of #datetime.today().display("[month repr:long] [year]") is awaiting review.
]

#pagebreak()
== Limitations <limitations_of_first_refactoring>
To keep the scope of the implementation managable it was decided to leave some features out.
These limitations however could be lifted in a future version.
The implementation is built so it actively looks for these patterns and does not offer the refactoring operation if one is present.

=== Combined Concept Requirements
Handling combined `requires` clauses would certainly be possible,
however it would increase the complexity of the refactoring code significantly.
Since working on the LLVM project is new for all participants, it was decided that this feature will be left out.
#figure(
  ```cpp
  template <typename T, typename U>
  requires foo<T> && foo<U>
  void f(T)
  ```,
  caption: "Combined concept requirement",
)

=== Class Templates
Supporting class templates would have been feasible,
but a decision was made to exclude this possibility due to time constraints and in favor of maintaining simplicity in the initial refactoring implementation.
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
The complexity associated with managing this particular case is considerable, while the potential use case is minimal.
As a result, a decision was made not to incorporate this capability.

// COR Wie würde der Code nach dem Refactoring aussehen, wenn erfolgreich?
// COR Was wenn foo<T> kein concept ist? Könnte ein Variablen Template sein. Es nicht zu transformieren wäre korrekt, da es nicht in der Template-Deklaration verwendet werden kann.

#figure(
  ```cpp
  template <typename T>
  requires std::convertible_to<int, T>
  void f(T)
  ```,
  caption: "Function template with multiple type arguments",
)

#pagebreak()
== Usage <first_refactoring_usage>
The refactoring is available as a code action to language server clients and is available on the whole `requires` clause.

=== VS Code
To use the feature the user needs to hover over the requires clause (e.g. `std::integral<T>`),
then right click to show the code options.
To see the possible refactorings the option "Refactor..." needs to be clicked and then the newly implemented refactoring "Inline concept requirement" will appear within the listed options.
How this can look like is shown in @inline_concept_requirement_usage_in_vs_code.

#figure(
  image("../images/screenshot_inline_concept.png", width: 50%),
  caption: [
    Screenshot showing the option to inline a concept requirement in VS Code
  ],
) <inline_concept_requirement_usage_in_vs_code>

=== Neovim
@first_refactoring_usage_in_vim shows how the refactoring looks like before accepting it in Neovim.
The cursor needs to be placed on the requires clause before triggering the listing of code actions.

#figure(
  image("../images/first_refactoring_usage_in_vim.png", width: 80%),
  caption: [
    Screenshot showing the option to inline a concept requirement in Neovim
  ],
) <first_refactoring_usage_in_vim>
