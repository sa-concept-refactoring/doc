#include <concepts>
#include <iostream>
#include <numeric>
#include <vector>

using namespace std;

template<typename T>
concept Foo = requires(T a) {
  { a.abc() } -> std::same_as<int>;
};

// *******************************************
// * Standard case
// *******************************************

// BEFORE:
template <typename  T> 
void f() requires std::integral<T>
{}

// AFTER:
// template <std::integral T>
// void f(T) {}

// ******************************************

// BEFORE
template<typename T>
void bar(T a) requires Foo<T> {
  a.abc();
}

// AFTER
// void f(std::integral<T> auto x) {}

// *******************************************
// * Requires before function
// *******************************************

// BEFORE
template<typename T> 
requires std::integral<T>
void f(T) {}

// AFTER
// template <std::integral T>
// void f(T) {}

// *******************************************
// * Example with template template parameter
// *******************************************

// BEFORE
template <template <typename> class Foo, typename T>
void f2() requires std::integral<T>
{}

// *******************************************
// * [NOT SUPPORTED] Multiple requires clauses
// *******************************************

// BEFORE
template <typename T>
void doubleCheck(T) requires std::integral<T> && std::floating_point<T>
{}

// *******************************************
// * [NOT SUPPORTED] Other cases
// *******************************************

// Non-Function Template
template <typename T>
concept FooB = requires(T x) {
    {x} -> std::convertible_to<int>;
};

// Template Template parameters
template <template <typename> class Container, typename T>
concept ContainerWithAllocator = requires {
    typename Container<T>;
};

// Example with multiple requires clauses => no conversion possible
template <typename T>
requires std::integral<T> || std::floating_point<T>
constexpr double Average(std::vector<T> const &vec){
  const double sum = std::accumulate(vec.begin(), vec.end(), 0.0);
  return sum / vec.size();
}

int main() {
  int number;

  cout << "Enter an integer: ";
  cin >> number;

  if (number > 5) {
    cout << "Foo ";
  } else {
    cout << "Bar ";
  }

  cout << "You entered " << number;

  cout << "Enter some integers to calculate the average (stop input by typing any char):";
  std::vector<int> ints;
  while (cin >> number)
    ints.push_back(number);

  cout << "Your average: " << Average(ints);

  return 0;
}


