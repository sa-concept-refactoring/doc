#import "@preview/tablex:0.0.4": tablex, colspanx, rowspanx, cellx
#import "progress-bar.typ": printProgressBar

#import "title-page.typ": luschtig

#show raw: it => {
  if (it.block) {
    block(
      fill: luma(0xF0),
      inset: 8pt,
      radius: 5pt,
      text(it)
    )
  } else {
    text(it)
  }
}

#show heading: it => {
  if (it.level == 1) {
    pagebreak(weak: true)
  }
  it
}

#show ref: it =>{
  if it.element != none and it.element.func() == heading {
    let number = numbering(it.element.numbering, ..counter(heading).at(it.element.location())).trim(".", at: end)
    link(it.target, it.element.supplement + " " + number + ", " + it.element.body)
  } else {
    it
  }
}

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

#include "chapters/abstract.typ"
#include "chapters/managementSummary.typ"

#set heading(numbering: "1.")
#show par: set block(below: 2em)
#show figure: set block(below: 2em)

#include "chapters/introduction.typ"
#include "chapters/analysis.typ"
#include "chapters/refactoringIdeas.typ"
#include "chapters/inlineConceptRequirement.typ"
#include "chapters/convertToAbbreviatedForm.typ"
#include "chapters/developmentProcess.typ"


= Conclusion <conclusion>
// - Zusammenfassung
// - Evaluation der Ergebnisse
// - Zielerreichung/offene Punkte
// - Ausblick, weiterführende Schritte

#set heading(numbering: none)

= Outlook

= Learnings

= Personal Reports
Notes Jeremy:
- No C++20 (no ranges, no concepts) in clangd itself

= Disclaimer
Parts of this paper were rephrased by GPT-3.5.

#include "chapters/glossary.typ"

#bibliography("bibliography.bib")

= Table of Figures
#outline(
  title: none,
  target: figure.where(kind: image),
)

= List of Listings
#outline(
  title: none,
  target: figure.where(kind: raw),
)

= Appendices

// - Relevante Anhänge
// - Meeting Protokolle
// - Vereinbarungen
// - (SA/BA): Persönliche Berichte (0.5-1 Seite)
// - Entwicklerdokumentation
// - User Dokumentation
// - Sonstige Protokolle (z.B. von Usability Tests)
