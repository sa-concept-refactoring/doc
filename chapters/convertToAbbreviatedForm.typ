#import "@preview/tablex:0.0.4": tablex, colspanx, rowspanx, cellx, hlinex

= Refactoring — Convert Function Template to Abbreviated Form <convert_to_abbreviated_form>
For the second refactoring, a subset of the third idea (@third_idea) should be implemented.
It replaces explicit function template declarations with abbreviated declarations using auto parameters.
This tweak helps reduce the number of lines and makes the code more readable.
@second_refactoring_capabilities shows examples of what this refactoring will be able to do.

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
  caption: "Capabilities of the second refactoring",
) <second_refactoring_capabilities>

#pagebreak()
== Analysis
The analysis will look at the captured elements (@second_refactoring_captured_elements), call site implications (@call_site_implications),
and the impact of the refactoring on the abstract syntax tree (@second_refactoring_ast).

=== Captured Elements <second_refactoring_captured_elements>
@second_refactoring_captured_elements shows the captured elements and their purpose.
A reference to them will be stored as a member of the tweak object during the preparation phase and used during the application phase.

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
  caption: "Elements captured for the second refactoring",
) <second_refactoring_captured_elements_figure>

=== Call Site Implications <call_site_implications>
The refactoring must not change the signature of the target method.
In regard to this specific refactoring, the order of type parameters must stay the same.
This is only the case if the auto parameters are in the same order as their original template parameters.

For example the two methods in @call_site_differences result in two different signatures.
When calling these methods with ```cpp foo<int, float>(1.0, 2)``` only the version on the left would compile,
as the parameter types would be `int` for `param1` and `float` for `param2`.
The second version would be the opposite, `int` for `param1` and `float` for `param2`, which then breaks the call as the parameter types don't match.

#figure(
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
  caption: [Example to illustrate call site differences of auto params],
) <call_site_differences>

#pagebreak()
=== Abstract Syntax Tree <second_refactoring_ast>
As can be seen in @second_refactoring_ast_figure, the AST transformation of this refactoring is very minimal.
The only change is that the explicit type parameter name is replaced with a generated one.

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
  caption: "Example AST tranformation of second refactoring",
) <second_refactoring_ast_figure>

#pagebreak()
== Implementation
The most challenging part of this refactoring was figuring out where template parameters are being used, as the refactoring only applies if there is exactly one usage of the parameter and that usage is as a function parameter type.

Initially it was tried to perform a symbol lookup in the index clangd holds, however this led to no results.
Our theory is that this is due to the target being a template parameter, which has no proper symbol id in the context of the template declaration, as it is not a concrete instance of a type.

Afterward, we looked at the way the "find references" LSP feature is implemented in clangd and found out that there is a helper class called `XRefs` which implements a `findReferences` function which can deal with template functions.
Unfortunately the result of this method call cannot be traced back to the AST.

In the end, the `findReferences` call is only being used to find the number of references to a given template parameter.

// To conclude, for each template parameter we call `findReferences` to count how many references to it exist.


// - Big preparation phase
// - Find references for each template parameter
// - Check order of template parameters

#pagebreak()
== Limitations
TODO

// #figure(
//   table(
//     columns: (1fr, 1.5fr),
//     align: start,
//     [*Check*], [*Reasoning*],
//     [
//       A template definition needs to be in place.
//     ],
//     [
//       If the template definition is not present the logic of this refactoring can't be applied.
//     ],
//     [
//       The template type parameter is not used within the body.
//     ],
//     [
//       If the type parameter is used in the body it cannot be replaced with an ```cpp auto``` param.
//     ],
//     [
//       The order of template parameters is the same as their occurence as function parameters.
//     ],
//     [
//       The function signature would change otherwise.
//     ],
//     [
//       The parameter type is not used within a container (e.g. `map`, `set`, `list`, `array`)
//     ],
//     [
//       The ```cpp auto``` keyword cannot be used in this context.
//     ],
//     [
//       No requires clause should be present.
//     ],
//     [
//       As the refactoring is removing the type parameter the ```cpp requires``` clause would not be valid anymore.
//     ]
//   ),
//   caption: "Checks made during the preparation phase of the \"Convert Function Template to Abbreviated Form\" refactoring",
// )

// Kommentar Jeremy: Das bruchemer glaub ned wemmer d'Checks obe dra hend.
// ==== Not Supported Cases

// ```cpp
// // The keyword `auto` can't be used within containers
// template<typename T>
// auto foo(vector<T> param) -> void {}

// template<typename T>
// auto foo(list<T> param) -> void {}

// template<class T, size_t N>
// auto foo(T (&a)[N], int size) -> void {}

// // Using template declaration multiple times for function parameters
// template<std::integral T>
// auto foo(T param, T anotherParam) -> void {}

// // Template type parameter is used within the function body
// template<std::integral T>
// auto foo(T param) -> void {
//   if constexpr (std::is_unsigned_v<T>) {
//       std::cout << "The type is an unsigned integer." << std::endl;
//   } else {
//       std::cout << "The type is not an unsigned integer." << std::endl;
//   }
// }

// // Order in template definition different then the function parameters
// // destroys calling of the function
// // e.g.: foo<string, int)(2, "hi");
// // when making both param auto the order of the types in `<>` changes!! 
// template <typename T, std::integral U>
// auto foo(U param, T param2) -> void {}
// ```

#pagebreak()
== Testing
// TODO: add tests to appendix

#pagebreak()
== Usage
TODO
// To use the refactoring the cursor can be anywhere on or within the function. 
