= Project Management
// - Vorgehen (Prozess, Reviews, Workflows, Qualitätssicherung)
// - Projektplan, Vergleich ursprüngliche Planung, effektive Ausführung
// - Zeiterfassung (Stunden pro Woche/Stunden pro Task-Kategorie, wie Implementation Doku, Meeting, etc.)
// Hinweis: Keine Liniendiagramme für die Darstellung von Zeit/Arbeitsaufwand pro Woche

This section looks at how the project was 

== Methods
Development work occurred on both Linux and Windows utilizing CLion with the Ninja build system.
The language server features were tested using Visual Studio Code and the clangd extension.

#set page(flipped: true)

== Project Plan

The project plan was developed in week 3 after the ideas for the refactoring features were set.
Without concrete ideas a good project plan can not be worked out.
Each phase of a refactoring implementation is planned with the same amount of time as the implementation itself.
The documentation part is spread over the whole project duration as it is important to keep it up to date and consistent.
All implementation work should be done two weeks before the end as the documentation needs to be finished and ready for hand in.

#let numberOfWeeks = 15

#let epic(
  title: none,
  startWeek: int,
  backgroundColor: color,
  foregroundColor: color,
  inset: 8pt,
  textSize: 0.9em,
  itemStroke: white + 2pt,
  items
) = [
  #let itemBox(width, content) = box(
    width: 100% * width / (numberOfWeeks - (startWeek - 1)),
    inset: inset,
    fill: backgroundColor,
    stroke: itemStroke,
    text(
      spacing: 100%,
      fill: foregroundColor,
      weight: "bold",
      content
    ),
  )

  #pad(left: 100% * (startWeek - 1) / numberOfWeeks, [
    #set text(size: textSize)
    #if title != none [
      *#title* \
    ]
    #set text(spacing: 0%)
    #for item in items {
      itemBox(item.at(0), item.at(1))      
    }
  ])
]

#epic(
  startWeek: 1,
  backgroundColor: aqua,
  foregroundColor: black,
  inset: 4pt,
  textSize: 1em,
  itemStroke: none,
  range(1, numberOfWeeks + 1)
    .map(weekNum => (1, align(center, [w#str(weekNum)]))),
)

#epic(
  title: "Documentation",
  startWeek: 1,
  backgroundColor: blue,
  foregroundColor: white,
  (
    (2, "Setup"),
    (8, "Ongoing documentation"),
    (2, "Refinement"),
    (2, [Abstract & MS #footnote[Management Summary]]),
    (1, "Final"),
  ),
)

#epic(
  title: "1. Refactoring",
  startWeek: 2,
  backgroundColor: green,
  foregroundColor: white,
  (
    (2, "Analysis"),
    (2, "Implementation"),
    (2, "Refinement"),
    (2, "Pull Request"),
  ),
)

#epic(
  title: "2. Refactoring",
  startWeek: 6,
  backgroundColor: orange,
  foregroundColor: white,
  (
    (2, "Analysis"),
    (2, "Implementation"),
    (2, "Refinement"),
    (2, "Pull Request"),
  ),
)

#pagebreak()
#set page(flipped: false)

== Time Tracking
To monitor our working hours effectively, we have established a straightforward Google Sheet where we meticulously record information about our tasks, such as who is assigned to them, the task's nature, and the duration spent on each task. Additionally, each entry includes a brief comment detailing the specific work performed during that time.

// TODO small summary of time tracking