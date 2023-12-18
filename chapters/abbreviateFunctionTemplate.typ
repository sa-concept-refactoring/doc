#import "@preview/tablex:0.0.4": tablex, colspanx, rowspanx, cellx, hlinex

#let refactoring_name = "Abbreviate Function Template"

= Refactoring — #refactoring_name <abbreviate_function_template>
For this refactoring, another subset of the first idea (@idea_requirement_transformation) is implemented.
It replaces explicit function template declarations with abbreviated declarations using `auto` parameters.
This tweak helps reduce the number of lines and makes the code more readable.
@second_refactoring_capabilities shows examples of what this refactoring is able to do.

A detailed analysis, including call-site implications, can be found in @abbreviate_function_template_analysis.
Implementation details are discussed in @abbreviate_function_template_implemenation and limitations are explored in @abbreviate_function_template_limitations.
Finally, the usage of the refactoring is shown in @abbreviate_function_template_usage.

#figure(
  table(
    columns: (1fr, 1fr),
    align: horizon,
    [*Before*], [*After*],
    [
      ```cpp
      template <typename T>
      auto f(T param)
      ```
    ],
    [
      ```cpp
      auto f(auto param)
      ```
    ],
    [
      ```cpp
      template <typename ...T>
      auto f(T ...p)
      ```
    ],
    [
      ```cpp
      auto f(auto ...p)
      ```
    ],
    [
      ```cpp
      template <std::integral T>
      auto f(T param)
      ```
    ],
    [
      ```cpp
      auto f(std::integral auto param)
      ```
    ],
    [
      ```cpp
      template <std::integral T>
      auto f(T const ** p)
      ```
    ],
    [
      ```cpp
      auto f(std::integral auto const ** p)
      ```
    ],
  ),
  caption: [ Capabilities of the "#refactoring_name" refactoring ],
) <second_refactoring_capabilities>

#pagebreak()
== Analysis <abbreviate_function_template_analysis>
The analysis looks at the captured elements (@second_refactoring_captured_elements), call site implications (@call_site_implications),
and the impact of the refactoring on the abstract syntax tree (@second_refactoring_ast).

=== Captured Elements <second_refactoring_captured_elements>
@second_refactoring_captured_elements_figure shows the captured elements and their purpose.
A reference to them is stored as a member of the tweak object during the preparation phase and used during the application phase.

#figure(
  tablex(
    columns: 2,
    auto-vlines: false,
    ```cpp
    template <std::integral T>
    ^^^^^^^^^^^^^^^^^^^^^^^^^^
    auto f(T param) -> void {}
    ```,
    [
      *Template Declaration* \
      Will be removed.
    ],
    ```cpp
    template <std::integral T>
              ^^^^^^^^^^^^^
    auto f(T param) -> void {}
    ```,
    [
      *Template Parameter Restriction* \
      Will be used in the parameter type replacement.
    ],
    ```cpp
    template <std::integral T>
    auto f(T param) -> void {}
           ^
    ```,
    [
      *Parameter Type* \
      Will be replaced with template parameter \ restriction and ```cpp auto```.
    ],
  ),
  caption: [ Elements captured for the "#refactoring_name" refactoring ],
) <second_refactoring_captured_elements_figure>

=== Call Site Implications <call_site_implications>
The refactoring must not change the signature of the target method.
In regard to this specific refactoring, the order of type parameters must stay the same.
This is only the case if the `auto` parameters are in the same order as their original template parameters.

For example the two methods in @call_site_differences result in two different signatures.
When calling these methods with ```cpp foo<int, float>(1.0, 2)``` only the version on the left would compile,
as the types of the arguments would be `float` for `param1` and `int` for `param2`.
The second version would be the opposite, `int` for `param1` and `float` for `param2`, which then breaks the call as the parameter types do not match.

#figure(
  kind: image,
  grid(
    columns: (auto, auto),
    gutter: 1em,
    align(start)[
      ```cpp
      template<typename T, typename U>
      auto foo(U param1, T param2)
      ```
    ],
    align(start + horizon)[
      ```cpp
      auto foo(auto param1, auto param2) 
      ```
    ]
  ),
  caption: [Example to illustrate call site differences of auto parameters],
) <call_site_differences>

// COR Andere Einschränkungen?

#pagebreak()
=== Abstract Syntax Tree <second_refactoring_ast>
As can be seen in @second_refactoring_ast_figure, the AST transformation of this refactoring is very minimal.
The only change is that the explicit type parameter name is replaced with a generated one.

// COR What is missing?
It is interesting to see how abstract the abstract syntax tree really is in this case.
It does not reflect the source code as closely as in @inline_concept_requirement (@first_refactoring_ast_analysis).

#figure(
  tablex(
    columns: (5pt, 160pt, 30pt, 240pt),
    align: center + horizon,
    auto-vlines: false,
    auto-hlines: false,
    [],
    [ *Before* ],
    [],
    [ *After* ],
    hlinex(),
    [],
    ```cpp
    template<std::integral T>
    auto f(T param) -> void
    {}
    ```,
    [],
    ```cpp
    auto f(std::integral auto param) -> void
    {}
    ```,
    hlinex(),
    colspanx(4)[#image("../images/ast_second_refactoring.png")],
  ),
  caption: [ Example AST tranformation of "#refactoring_name" refactoring ],
) <second_refactoring_ast_figure>

#pagebreak()
== Implementation <abbreviate_function_template_implemenation>
The most challenging part of this refactoring was figuring out where template parameters are being used,
as the refactoring only applies if there is exactly one usage of the parameter and that usage is as a function parameter type.

Initially, it was tried to perform a symbol lookup in the index clangd holds, but this led to no results.
This is very likely due to the target being a template parameter,
which has no proper symbol ID in the context of the template declaration, as it is not a concrete instance of a type.

Afterward, the way the "find references" LSP feature is implemented in clangd was analyzed.
It uses a helper class called `XRefs` which implements a `findReferences` function that can deal with template functions.
Unfortunately, the result of this method call cannot be traced back to the AST.

In the end, the `findReferences` call is only used to find the number of references to a given template parameter.
This number is an important point of reference to see if the refactoring applies.

- #[
  If there is *only one reference*, it would mean that the template parameter is declared but never used.
  In this case, the refactoring cannot apply, since the template parameter would cease to exist, resulting in a different function signature.
]

- #[
  If there are *exactly two references*, it means that one of those is the definition and there is at least one usage of it.
  Figuring out if the usage is a function parameter is done in a later step.
]

- #[
  If there are *more than two references*, it means that there are either two function parameters with the same type
  or there is at least one usage outside of function parameters (for example the body of the function).
  In both cases, the refactoring cannot apply, since replacing both usages with `auto` would result in two template parameters where there used to be just one, thus changing the function signature.
]

// COR Was ist nun mit Funktionen und Arrays?
As a next step, the function parameters are iterated over to verify that each template parameter type occurs as a function parameter and that the order is the same.
In addition, the type qualifiers are extracted, which consist of reference kind, constness, and pointer type.

The application phase is rather simple in comparison.
In a first step, the template declaration is removed, and in a second step, the types of the function parameters are updated.
The information needed for this has been collected during the preparation phase.

#[
  #set heading(numbering: none)

  === Testing
  A lot of manual tests were performed using a test project.
  Debug inspections were performed often to verify assumptions.
  Unit tests were also written as described in @testing, which consist of a total of 14 tests, 4 of them availability tests, 4 unavailability tests and 6 application tests.
  This is a similar extent to which existing refactorings are tested.

  === Pull Request
  The implementation has been submitted upstream as a pull request @pull_request_of_second_refactoring and as of #datetime.today().display("[month repr:long] [year]") is awaiting review.
]

== Limitations <abbreviate_function_template_limitations>
There are limits to this refactoring.
Some of them are given by the language or compiler and some are intentional, because otherwise the scope of the refactoring would have increased drastically.

=== Templated Function Parameters
If a function parameter is a templated parameter like ```cpp std::vector<T>``` the refactoring cannot apply.
// TODO: Ask Corbat if he knows why. I could not find the source of the error message.
// COR [parameter] Argument
The reason for this is that `auto` cannot be used as a template parameter.

#figure(
  ```cpp
  template <typename T>
  void foo(std::vector<T> param)
  ```,
  caption: "Templated function parameter",
)

=== Template Arguments Used Multiple Times
This is an inherit limitation of the refactoring.
// COR [argument] parameter
If for example the same template argument is used for multiple function parameters, it means that all of them will have the same type when instantiated.
Would they be replaced with `auto`, each of them would result in a different type.

This limitation also applies if the template argument is used anywhere else.
This includes the return type and the body of the function.
// COR [always] Also sollte möglich sein ein Gegenbeispiel zu finden. Ich würde sagen "likely". Es muss nicht unbedingt nur das Verhalten sein, es könnte auch den Code semantisch inkorrekt machen.
Replacing one template parameter with multiple `auto` keywords always breaks the behavior of the function.

#figure(
  ```cpp
   template<std::integral T>
   auto foo(T param, T anotherParam) -> void {}
  ```,
  caption: "Template argument used for multiple function parameters",
)

=== Requires Clauses
Functions with `requires` clauses are not supported.
As a workaround the previously implemented refactoring (@inline_concept_requirement) can be used first.

#figure(
  ```cpp
  template <typename T>
  void f(T) requires foo<T> {}
  ```,
  caption: "Function template with requires clause",
)

== Usage <abbreviate_function_template_usage>
The refactoring is available as a code action for language server clients.
To use it the cursor can be placed anywhere within the function.

=== VS Code
To use the feature the user needs to hover over any part of the function, then right click to show the code options.
To see the possible refactorings the option "Refactor..." needs to be clicked and then the newly implemented refactoring "Abbreviate Function Template" will appear within the listed options.
How this can look like is shown in @abbreviate_function_template_usage_in_vs_code.

#figure(
  image("../images/abbreviate_function_template_usage_in_vs_code.png", width: 50%),
  caption: [
    Screenshot showing the option to abbreviate a function template in VS Code
  ],
) <abbreviate_function_template_usage_in_vs_code>

=== Neovim
@abbreviate_function_template_usage_in_vim shows how the refactoring looks like before accepting it in Neovim.
The cursor can be placed anywhere within the function before triggering the listing of code actions.

#figure(
  image("../images/abbreviate_function_template_usage_in_neovim.png", width: 80%),
  caption: [
    Screenshot showing the option to abbreviate a function template in Neovim
  ],
) <abbreviate_function_template_usage_in_vim>
