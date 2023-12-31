= Project Management <project_management>

The approach of the project is explained in @approach.
The planning of the project is looked into in @project-plan,
including a comparative analysis between the initial plan and its effective implementation.
Finally, @time-tracking provides a summarized overview of the allocated working hours coupled with a reflective assessment of the time invested.

== Approach <approach>

To discuss the ongoing process a weekly meeting with the advisor was held where it was discussed what work has been done and what is planned for the next week.
Receiving a feedback of the ongoing development is quite important as the direction we are going towards can be assessed and adjusted in just a week.

The development is managed using GitHub as described in @development_process.
For better overview on what is already done, pull requests are used to review each others changes.
This same method is also used for writing the documentation which allows tracking all changes easily.

For the documentation, Typst @typst was used, which is a new markup-based typesetting system.
In VS Code, there is an extension supporting Typst @typst_extension, no other tool is needed.
After the document had a stable state, pull requests were used here as well to double-check that both team members agree on what the other was writing about.
GitHub issues @github_issues were sometimes also used to keep track of the documentations state.

The project is split into three main steps.

/ Project Setup : #[
  Before implementing a project, a setup needs to be in place, therefore some research needed to be done to figure out what is needed to build the LLVM project and clangd specifically.
  The setup needed to work on Linux and Windows as both systems were used for this project.
]

/ Analysis : #[
  The analysis consists of a lot of research on how the clangd language server works and how it is communicating with the IDE.
  This step also contains cathering all knowledge needed for implementation, such as looking into the idea of concepts and figuring out which refactoring features would be a good addition to have within the language server.
]

/ Implementation and Finalization: #[
  In the implementation phase the actual refactoring features are implemented according to the analysis.
  To make the implementation ready for contribution it needs to be refined, which means the code needs to be readable and follow the development guidelines @llvm_coding_standards.
  When the refinement is done, a pull request can be created to contribute the changes upstream and to finalize the implementation step.
]

#set page(flipped: true)

== Project Plan <project-plan>

The project plan was developed in week 3 after the ideas for the refactoring features were set.
Without concrete ideas a good project plan can not be worked out.
The documentation part is spread over the whole project duration as it is important to keep it up to date and consistent.
All implementation work should be completed two weeks before the deadline to ensure that the documentation is finished and ready for submission.

@project-plan-figure shows the project plan (on top, in lighter hue) compared to the actual progress made (on the bottom, in darker hue).
There is almost no deviation from the plan, except for the first refactoring, which was implemented faster than expected, and the documentation, where the abstract and management summary were written before the refinement phase, because of the earlier submission date.

#[
#show figure: set block(width: 100%)
#figure([

#let numberOfWeeks = 14

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
    (7, "Ongoing documentation"),
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
    (7, "Ongoing documentation"),
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
    (2, [Refinement & PR #footnote[Pull Request]<PR>]),
  ),
)
#epic(
  startWeek: 2,
  backgroundColor: maroon,
  foregroundColor: white,
  (
    (1, "Analysis"),
    (3, "Implementation"),
    (2, [Refinement & PR @PR]),
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
    (2, [Refinement & PR @PR]),
  ),
)
#epic(
  startWeek: 6,
  backgroundColor: orange,
  foregroundColor: white,
  (
    (1, "Analysis"),
    (4, "Implementation"),
    (2, [Refinement & PR @PR]),
  ),
)

#v(1cm)
], caption: "Project plan") <project-plan-figure>
]

#pagebreak()
#set page(flipped: false)

== Time Tracking <time-tracking>

To monitor the working hours effectively, a Google Sheet was established where information about the time spent was meticulously recorded.
Each record contains a date, the amount of time spent, name of executor, task category and a brief comment detailing the specific work performed during that time.

@time-tracking-report-1 and @time-tracking-report-2 show the total time spent on each category per project week.
@time-invested-per-category shows the share of time invested per category.
Most of the time spent was invested into the documentation and implementation, with the former being the main focus at the end of the project.

@time-invested-per-person shows the time spent by each project author.
Both authors contributed a similar amount to both documentation and implementation.

#figure(
  image("../images/time_invested_per_category_and_project_week.png"),
  kind: table,
  caption: "Time invested per category and project week",
) <time-tracking-report-1>

#figure(
  image("../images/time_invested_per_category_and_project_week.svg"),
  caption: "Time invested per category and project week",
) <time-tracking-report-2>

#figure(
  image("../images/time_invested_per_category.svg", width: 80%),
  caption: "Time invested per category",
) <time-invested-per-category>

#figure(
  image("../images/time_invested_per_person.svg", width: 80%),
  caption: "Time invested per person",
) <time-invested-per-person>
