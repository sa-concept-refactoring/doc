= Project Management
// [] Vorgehen (Prozess, Reviews, Workflows, Qualitätssicherung)
// [x] Projektplan, 
//    [] Vergleich ursprüngliche Planung, effektive Ausführung
// [x] Zeiterfassung (Stunden pro Woche/Stunden pro Task-Kategorie, wie Implementation Doku, Meeting, etc.)
// Hinweis: Keine Liniendiagramme für die Darstellung von Zeit/Arbeitsaufwand pro Woche

This section describes the approach of the project as well as the project plan and time tracking.
In @approach, it is explained how the project was approached.
@project-plan, looks into the planning of the project, including a comparative analysis between the initial plan and its effective implementation.
Additionally, @time-tracking, provides a summarized overview of the allocated working hours coupled with a reflective assessment of the time invested in the reflects on the time invested.

== Approach <approach>

Development work occurred on both Linux and Windows utilizing CLion with the Ninja build system.
The language server features were tested using Visual Studio Code and the clangd extension.

The project is split into three main steps.
+ Project Setup
+ Analysis
+ Implementation

/ Project Setup : #[
  Before starting with the implementation, a project setup needs to be in place, which requires some research to be done to figure out what is needed to extend the LLVM project with new features.
  The setup needed to work on Linux and Windows as both systems were used for this project.
]

/ Analysis : #[
  The analysis part consists of a lot of research on how the clangd language server works and how it is communicating with the IDE.
  This step also contains collecting all knowledge needed for implementation, such as looking into the idea of concepts and figuring out what refactoring features would be a good addition to have within the language server.
]

/ Implementation : #[
  The implementation it self was one of the smallest steps beside the project setup.
]

#set page(flipped: true)

== Project Plan <project-plan>

The project plan was developed in week 3 after the ideas for the refactoring features were set.
Without concrete ideas a good project plan can not be worked out.
Each phase of a refactoring implementation is planned with the same amount of time as the implementation itself.
The documentation part is spread over the entire project duration as it is important to keep it up to date and consistent.
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

== Time Tracking <time-tracking>

To monitor the working hours effectively, a Google Sheet was established where the time spent on each task was meticulously recorded.
Each record contains the date of execution, time spent, name of executioner, task category and a brief comment detailing the specific work performed during that time.

The summary in @time-tracking-report shows the total time spent on each category per week.

// TODO: update image
#figure(
  image("../images/time_tracking_report.png"),
  caption: [
    Hours worked per week and category.
  ],
) <time-tracking-report>