#set align(center)

#show raw: it => {
  let backgroundColor = luma(0xF0)
  if (it.block) {
    block(
      fill: backgroundColor,
      inset: 8pt,
      radius: 5pt,
      it,
    )
  } else {
    box(
      fill: backgroundColor,
      outset: 2pt,
      radius: 2pt, 
      it,
    )
  }
}

== Inline Concept Requirement

#v(2mm)

#table(
  columns: 3,
  stroke: none,
  [
    *Before*
    #v(-2mm)
    ```cpp
    template <typename T>
    void foo(T) requires std::integral<T>
    ```
  ],
  [
    #set align(start + horizon)
    #set text(size: 2em)
    #sym.arrow.r
  ],
  [
    *After*
    #v(-2mm)
    ```cpp
    template <std::integral T>
    void foo()
    ```
  ],
)

#v(1cm)

== Abbreviate Function Template

#v(2mm)

#table(
  columns: 3,
  stroke: none,
  [
    *Before*
    #v(-2mm)
    ```cpp
    template <std::integral T>
    void foo(T param)
    ```
  ],
  [
    #set align(start + horizon)
    #set text(size: 2em)
    #sym.arrow.r
  ],
  [
    *After*
    #v(-2mm)
    ```cpp
    void foo(std::integral auto param)
    ```
  ],
)