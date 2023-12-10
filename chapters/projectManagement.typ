= Project Management
// [X] Vorgehen (Prozess, Reviews, Workflows, Qualitätssicherung)
// [x] Projektplan, 
//    [] Vergleich ursprüngliche Planung, effektive Ausführung
// [x] Zeiterfassung (Stunden pro Woche/Stunden pro Task-Kategorie, wie Implementation Doku, Meeting, etc.)
// Hinweis: Keine Liniendiagramme für die Darstellung von Zeit/Arbeitsaufwand pro Woche

@approach explains how the project was approached.
@project-plan looks into the planning of the project, including a comparative analysis between the initial plan and its effective implementation.
Finallly, @time-tracking provides a summarized overview of the allocated working hours coupled with a reflective assessment of the time invested.

== Approach <approach>

To discuss the ongoing process a weekly meeting with the advisor was held where it was discussed what work has been done and what is planned for the next week.
Receiving a feedback of the ongoing development is quite important as the direction we are going towards can be assessed and adjusted in just a week.

The development is managed using GitHub as described in @development_process.
For better overview on what is already done, pull requests are used to review each others changes.
This same method is also used for writing the documentation which allows tracking all changes easily.

The project is split into three main steps.
+ Project Setup
+ Analysis
+ Implementation and Finalization

/ Project Setup : #[
  Before implementing a project setup needs to be in place, therefore some research needed to be done to figure out what is needed to build the LLVM project and clangd specifically.
  The setup needed to work on Linux and Windows as both systems were used for this project.
]

/ Analysis : #[
  The analysis consists of a lot of research on how the clangd language server works and how it is communicating with the IDE.
  This step also contains gaining all knowledge needed for implementation, such as looking into the idea of concepts and figuring out what refactoring features would be a good addition to have within the language server.
]

/ Implementation and Finalization: #[
  In the implementation phase the actual refactoring features are implemented according to the analysis.
  To make the implementation ready for contribution it needs to be refined, which means the code needs to be readable and follow the development guidelines @llvm_coding_standards.
  When the refinement is done a pull request can be created to contribute the changes upstream and to finalize the implementation step.
]

#set page(flipped: true)

== Project Plan <project-plan>

The project plan was developed in week 3 after the ideas for the refactoring features were set.
Without concrete ideas a good project plan can not be worked out.
// TODO: Jeremy - Was isch mit dem Satz gmeint?
// Each phase of a refactoring feature is planned with the same amount of time as the implementation itself.
The documentation part is spread over the whole project duration as it is important to keep it up to date and consistent.
All implementation work should be complete two weeks before the end, as the documentation needs to be finished and made ready for hand in.

@project-plan-figure shows the project plan (on top, in lighter hue) compared to the actual progress made (on the bottom, in darker hue).
There is almost no deviation from the plan, except for the first refactoring, which was implemented faster than expected, and the documentation, where the abstract and management summary were written before the refinement phase, because of the earlier submission date.

#[
#show figure: set block(width: 100%)
#figure([

#let numberOfWeeks = 15

#let epic(
  title: none,
  startWeek: int,
  backgroundColor: color,
  foregroundColor: color,
  inset: 6.5pt,
  textSize: 0.75em,
  itemStroke: white + 2pt,
  items
) = [
  #set align(start)

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
      #v(0.6cm)
      *#title* \
    ]
    #set text(spacing: 0%)
    #for item in items {
      itemBox(item.at(0), item.at(1))      
    }
    #v(-0.6cm)
  ])
]

#epic(
  startWeek: 1,
  backgroundColor: aqua,
  foregroundColor: black,
  inset: 4pt,
  itemStroke: none,
  range(1, numberOfWeeks + 1)
    .map(weekNum => (1, align(center, [w#str(weekNum)]))),
)

#epic(
  title: "Documentation",
  startWeek: 1,
  backgroundColor: blue.lighten(50%),
  foregroundColor: white,
  (
    (2, "Setup"),
    (8, "Ongoing documentation"),
    (2, "Refinement"),
    (2, [Abstract & MS #footnote[Management Summary]<MS>]),
    (1, "Final"),
  ),
)
#epic(
  startWeek: 1,
  backgroundColor: blue,
  foregroundColor: white,
  (
    (2, "Setup"),
    (8, "Ongoing documentation"),
    (2, [Abstract & MS @MS]),
    (2, "Refinement"),
    (1, "Final"),
  ),
)

#epic(
  title: "1. Refactoring",
  startWeek: 2,
  backgroundColor: maroon.lighten(50%),
  foregroundColor: white,
  (
    (2, "Analysis"),
    (3, "Implementation"),
    (3, "Refinement & Pull Request"),
  ),
)
#epic(
  startWeek: 2,
  backgroundColor: maroon,
  foregroundColor: white,
  (
    (1, "Analysis"),
    (2, "Implementation"),
    (3, "Refinement & Pull Request"),
  ),
)

#epic(
  title: "2. Refactoring",
  startWeek: 6,
  backgroundColor: orange.lighten(50%),
  foregroundColor: white,
  (
    (2, "Analysis"),
    (3, "Implementation"),
    (3, "Refinement & Pull Request"),
  ),
)
#epic(
  startWeek: 6,
  backgroundColor: orange,
  foregroundColor: white,
  (
    (1, "Analysis"),
    (4, "Implementation"),
    (3, "Refinement & Pull Request"),
  ),
)

#v(0.6cm)
], caption: "Project Plan") <project-plan-figure>
]

#pagebreak()
#set page(flipped: false)

== Time Tracking <time-tracking>

To monitor the working hours effectively, a Google Sheet was established where information about the tasks was meticulously recorded.
Each record contains a date, the amount of time spent, name of executor, task category and a brief comment detailing the specific work performed during that time.

The summary in @time-tracking-report shows the total time spent on each category per week.

// TODO: update image
#figure(
  image("../images/time_tracking_report.png"),
  caption: [
    Hours worked per week and category
  ],
) <time-tracking-report>

Most of the time was invested into the documentation and implementation.
@time-spent-per-category shows the time spent per category in percentage. 

#figure(
  image("../images/time_spent_per_category.png", width: 90%),
  caption: [
    Time spent per category.
  ],
) <time-spent-per-category>
