#set align(center)

#text(2em)[
    *SA - Concept Refactoring*
]

#text(1.5em)[
    #datetime.today().display("[day].[month].[year]")
    #v(1em)
    Jeremy Stucki \ Vina Zahnd
    #v(2em)
    _Supervisor:_ \ Thomas Corbat
]

#v(2em)

#figure(
  image("images/cpp_meme.jpg", width: 70%),
  caption: [
    A meme to lighten the mood
  ],
)

#set align(bottom)
#image("images/ost_logo.svg", height: 2cm)
#set align(top)

#pagebreak()

#set align(left)
#set page(numbering: "1 / 1")

= Abstract
TODO

#pagebreak()
#outline(title: "Table of Contents")
#pagebreak()

#set heading(numbering: "1.")

= Test
Bla bla. @larman_applyingUmlAndPatterns_2004

#pagebreak()
#bibliography("bibliography.bib")

#pagebreak()
#set heading(numbering: none)

= Table of Figures
#outline(
  title: none,
  target: figure.where(kind: image),
)
