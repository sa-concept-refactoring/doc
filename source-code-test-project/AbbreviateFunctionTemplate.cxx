#include <concepts>
#include <list>
#include <vector>
#include <iostream>
#include <type_traits>

using namespace std;

// *******************************************
// * Standard case
// *******************************************

// BEFORE
template <typename T>
auto foo1(T param) {}

// AFTER
auto foo2(auto param) {}

// ******************************************

// BEFORE
template <std::integral T>
auto foo3(T param) -> void {}

// AFTER
auto foo4(std::integral auto param) -> void {}

// *******************************************
// * Templated concept as parameter
// *******************************************

// BEFORE
template <std::convertible_to<int> T>
auto foo5(T param) -> void {}

// AFTER
auto foo6(std::convertible_to<int> auto param) -> void {}

// *******************************************
// * Multiple parameters
// *******************************************

// BEFORE
template <typename T, typename U>
auto foo7(T param, U param2) -> void {}

// AFTER
auto foo8(auto param, auto param2) -> void {}

// ******************************************

// BEFORE
template <typename T, std::integral U>
auto foo9(T param, U param2) -> void {}

// AFTER
auto foo10(auto param, auto param2) -> void {}

// *******************************************
// * Aggregates
// *******************************************

// BEFORE
template <typename...T>
auto fooVar(T...params) -> void{}

// AFTER
auto fooVarTerse(auto ...params) -> void{}

// *******************************************
// * Pointer of a pointer
// *******************************************

// BEFORE
template<std::integral T>
auto foo11(T const ** Tpl) -> void {}

// AFTER
auto foo12(std::integral auto const ** Values) -> void {}

// *******************************************
// * [Not Possible] Collections
// *******************************************

// The keyword `auto` can't be used within containers
template<typename T>
auto foo40(vector<T> param) -> void {}

template<typename T>
auto foo41(list<T> param) -> void {}

template<class T, size_t N>
auto foo42(T (&a)[N], int size) -> void {}

// Using template declaration multiple times for function parameters
template<std::integral T>
auto foo43(T param, T anotherParam) -> void {}

// Template type parameter is used within the function body
template<std::integral T>
auto foo44(T param) -> void {
    if constexpr (std::is_unsigned_v<T>) {
        std::cout << "The type is an unsigned integer." << std::endl;
    } else {
        std::cout << "The type is not an unsigned integer." << std::endl;
    }
}

// Order in template definition different then the function parameters
// destroys calling of the function
// e.g.: foo14<string, int)(2, "hi");
// when making both param auto the order of the types in `<>` changes!! 
template <typename T, std::integral U>
auto foo45(U param, T param2) -> void {}

// Requires clause
template <typename T>
requires std::integral<T>
auto foo46(T param) {}

template <typename T>
auto foo47(T param) requires std::integral<T> {}
