#import "@preview/tablex:0.0.4": tablex, colspanx, rowspanx, cellx

= Refactoring — Convert Function Template to Abbreviated Form <convert_to_abbreviated_form>
For the second refactoring a subset of the third idea (@third_idea) was implemented.
It replaces explicit function template declarations with abbreviated declarations using auto parameters.
This tweak helps to reduce the number of lines and makes the code more readable.

The following examples show how the code would be refactored.

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
)

#pagebreak()
== Call Site Implications

The refactoring must not change the signature of the method.
In this case the type parameter order must stay the same.
This is only the case if the auto parameters are in the same order as their original template arguments.

For example the two methods in @call_site_differences result in two different signatures.
When calling these methods with ```cpp foo<int, float>(1.0, 2)``` only the version on the left would compile as the parameter types would be `int` for `param1` and `float` for `param2`. The second version would be the opposite, `int` for `param1` and `float` for `param2`, which then breaks the call as the parameter types don't match.

For the refactoring this means that we can only support cases where the order of type arguments stays the same, so the template type arguments need to appear in the same order as the parameters using those types.

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
== Testing
// TODO: add tests to appendix

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
)

#pagebreak()
=== Prerequisites

#figure(
  table(
    columns: (1fr, 1.5fr),
    align: start,
    [*Check*], [*Reasoning*],
    [
      A template definition needs to be in place.
    ],
    [
      If the template definition is not present the logic of this refactoring can't be applied.
    ],
    [
      The template type parameter is not used within the body.
    ],
    [
      If the type parameter is used in the body it cannot be replaced with an ```cpp auto``` param.
    ],
    [
      The order of template parameters is the same as their occurence as function parameters.
    ],
    [
      The function signature would change otherwise.
    ],
    [
      The parameter type is not used within a container (e.g. `map`, `set`, `list`, `array`)
    ],
    [
      The ```cpp auto``` keyword cannot be used in this context.
    ],
    [
      No requires clause should be present.
    ],
    [
      As the refactoring is removing the type parameter the ```cpp requires``` clause would not be valid anymore.
    ]
  ),
  caption: "Checks made during the preparation phase of the \"Convert Function Template to Abbreviated Form\" refactoring",
)

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
=== AST Analysis

// NOTE @vina: same problem as above, the text can be copied...
To get to know the structure of the code which needs to be refactored, the AST tree gives a good overview.
In @second_refactoring the AST tree of a function template is shown with the corresponding source code on the right.

TODO: Write actual analysis

#figure(
  table(
    columns: (1fr, 1fr),
    align: center,
    stroke: none,
    [*AST*], [*Code*],
    image("../images/screenshot_ast_second_refactoring.png", width: 80%),
    [
      ```cpp
      template<std::integral T>
      auto f(T param) -> void
      {}
      ```
    ],
  ),
  caption: [
    AST analysis of second refactoring
  ],
) <second_refactoring>

== Usage
TODO
// To use the refactoring the cursor can be anywhere on or within the function. 
