#let title = "SA - Concept Refactoring"
#let authors = ( "Jeremy Stucki", "Vina Zahnd" )
#let supervisor = "Thomas Corbat"

#set document(
  title: title,
  author: authors,
)

#set align(center)

#text(2em)[
    *#title*
]

#text(1.5em)[
    #datetime.today().display("[day].[month].[year]")
    #line()
    #authors.join("\n")
    #line()
    _Supervisor:_ \ #supervisor
]

#v(2em)

#figure(
  image("images/cpp_meme.jpg", width: 70%),
  caption: [
    A meme to lighten the mood
  ],
)

#set align(bottom)
#image("images/ost_logo.svg", height: 3cm)
