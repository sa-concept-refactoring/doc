#import "@preview/tablex:0.0.4": tablex, colspanx, rowspanx, cellx
#import "progress-bar.typ": printProgressBar
#import "title-page.typ": luschtig

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

#show heading: it => {
  if (it.level <= 2) {
    pagebreak(weak: true)
  }

  it
}

#show ref: it => {
  if it.element != none and it.element.func() == heading {
    let number = numbering(it.element.numbering, ..counter(heading).at(it.element.location())).trim(".", at: end)
    link(it.target, emph(it.element.supplement + " " + number + ", " + it.element.body))
  } else {
    it
  }
}

#set terms(hanging-indent: 0pt)
#set text(font: ("Comic Sans MS")) if luschtig

#set page(numbering: "1 / 1") if not luschtig
#set page(
  footer: [
    #locate(loc => {
      let pageCounter = counter(page)
      let total = pageCounter.final(loc).first()
      let current = pageCounter.at(loc).first()
      printProgressBar(current / total, label: {str(current) + "/" + str(total)})
    })
  ],
) if luschtig

#include "title-page.typ"

#show figure: set block(below: 2em)
#set heading(numbering: "1.")
#show par: set block(below: 2em)

#include "chapters/abstract.typ"
#include "chapters/managementSummary.typ"

#outline(
  title: "Table of Contents",
  indent: auto,
  target: heading.where(level: 1).or(heading.where(level: 2))
)

#include "chapters/introduction.typ"
#include "chapters/analysis.typ"
#include "chapters/refactoringIdeas.typ"
#include "chapters/inlineConceptRequirement.typ"
#include "chapters/abbreviateFunctionTemplate.typ"
#include "chapters/developmentProcess.typ"
#include "chapters/projectManagement.typ"
#include "chapters/conclusion.typ"

= Disclaimer
Parts of this paper were rephrased by GPT-3.5.

#include "chapters/glossary.typ"

= Bibliography
#bibliography(
  title: none,
  "bibliography.bib",
)

= Table of Figures
#outline(
  title: none,
  target: figure.where(kind: image),
)

= Table of Tables
#outline(
  title: none,
  target: figure.where(kind: table),
)

= List of Listings
#outline(
  title: none,
  target: figure.where(kind: raw),
)

= Appendix
In this last section the personal reports from both authors can be found in which they reflect on the project (@report_jeremy and @report_vina).
It also contains the final version of the code written during this project (@source_code), which includes the implemented refactorings and the test project.

== Personal Report — Jeremy Stucki <report_jeremy>
#include "chapters/personalReportJeremy.typ"

== Personal Report — Vina Zahnd <report_vina>
#include "chapters/personalReportVina.typ"

== Assignment <assignment>

// TODO use assignment with signature for print version (!do not upload to github)
#figure(
  image("attachments/assignment_without_signature/assignment_without_signature_1.svg"),
)
#figure(
  image("attachments/assignment_without_signature/assignment_without_signature_2.svg"),
)
#figure(
  image("attachments/assignment_without_signature/assignment_without_signature_3.svg"),
)

== Source Code <source_code>
#outline(
  title: none,
  target: selector(heading).after(label("source_code_outline"))
) <source_code_outline>

#let showSourceFile(headingPrefix, filePath) = {
  let fileName = filePath.split("/").last()
  heading(headingPrefix + " — " + fileName, level: 3, numbering: none)

  set text(size: 0.75em)
  raw(
    read(filePath),
    lang: "cpp",
    block: true,
  )
}

#pagebreak()
#set page(flipped: true, columns: 2)

// The source files will be added by CI

// #showSourceFile("Inline Concept Requirement Refactoring", "first-refactoring-source-code/clang-tools-extra/clangd/refactor/tweaks/InlineConceptRequirement.cpp")
// #showSourceFile("Inline Concept Requirement Refactoring", "first-refactoring-source-code/clang-tools-extra/clangd/unittests/tweaks/InlineConceptRequirementTests.cpp")

// #showSourceFile("Abbreviate Function Template Refactoring", "second-refactoring-source-code/clang-tools-extra/clangd/refactor/tweaks/AbbreviateFunctionTemplate.cpp")
// #showSourceFile("Abbreviate Function Template Refactoring", "second-refactoring-source-code/clang-tools-extra/clangd/unittests/tweaks/AbbreviateFunctionTemplateTests.cpp")

// #showSourceFile("Test Project", "test-project-source-code/InlineConceptRequirement.cxx")
// #showSourceFile("Test Project", "test-project-source-code/AbbreviateFunctionTemplate.cxx")
