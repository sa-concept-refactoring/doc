#import "progress-bar.typ": printProgressBar

#let title = "SA - Concept Refactoring"
#let authors = ( "Jeremy Stucki", "Vina Zahnd" )
#let supervisor = "Thomas Corbat"
#let luschtig = false

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

#v(4em)

#if luschtig {
  [*Documentation Progress:*]
  locate(location => {
    let maxPageNumber = counter(page).final(location).first()
    let pagesRequired = 120
    let barWidth = maxPageNumber / pagesRequired

    printProgressBar(barWidth, label: {str(maxPageNumber) + "/" + str(pagesRequired)})
  })
}

#figure(
  image("images/newspaper.jpg", width: if luschtig { 50% } else { 60% }),
  caption: [
    Artistic interpretation of this project @title_image
  ],
)

#set align(bottom)
#image("images/ost_logo.svg", height: 3cm)

