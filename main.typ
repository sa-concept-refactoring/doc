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
  image("images/cpp_meme.jpg", width: 80%),
  caption: [
    A meme to lighten the mood
  ],
)

#pagebreak()

#set align(left)
#set page(numbering: "1 / 1")

= Abstract

#emph(text(gray)[
Der Abstract richtet sich an den Spezialisten auf dem entsprechenden Gebiet und beschreibt
daher in erster Linie die (neuen, eigenen) Ergebnisse und Resultate der Arbeit. (Aus
Anleitung Dokumentation FS21 vom SG-I).
- Der Umfang beträgt in der Regel eine halbe Seite Text
- Keine Bilder
])

= Management Summary

#emph(text(gray)[
- Das Management Summary richtet sich in der Praxis an die "Chefs des Chefs", d.h. an die
Vorgesetzten des Auftraggebers (diese sind in der Regel keine Fachspezialisten). Die Sprache
soll knapp, klar und stark untergliedert sein. (Aus Anleitung Dokumentation FS21 vom
SG-I)
- Der Umfang beträgt in der Regel 3-5 Seiten.
- Bilder sind hier sinnvoll
])

#pagebreak()
#outline(title: "Table of Contents")
#pagebreak()

#set heading(numbering: "1.")

= Test
Bla bla. @larman_applyingUmlAndPatterns_2004

= Introduction

#emph(text(gray)[
-  Beschreibung der Ausgangslage
- Beschreibung der Aufgabe
- Rahmenbedingungen
- Vorarbeiten
- Übersicht über die kommende Kapitel
])

= Analysis

#emph(text(gray)[
- Beschreibung des System-Kontexts
- Funktionale und nicht-Funktionale Anforderungen
- Use Cases/Scenarios/User Storys
- Bestehende Infrastruktur
- Abhängig vom Projekt: Risikoanalyse
- Beschreibung (externen) existierenden Schnittstellen
])

= Design

#emph(text(gray)[
- Beschreibung des Entwurfs der Lösung
- Architektur-Übersicht (Anmerkung das C4-Modell gibt eine gute Abstufung der Details)
- Internes Design (Subsysteme, Komponenten, Klassen)
- Extenes Design (UI)
- Entscheidungen: Alternativen erklären und Entscheidung nachvollziehbar begründen
])

= Implementation

#emph(text(gray)[
- Beschreibung interessanter Implementationsaspekte
- Verwendete Technologien
- Nebenläufigkeit
- Vorgehen beim Testing
])

= Resultate

#emph(text(gray)[
- Zielerreichung
- Auswertung Erfüllung der Anforderungen
- Projektmetriken
])

= Conclusion

#emph(text(gray)[
- Zusammenfassung
- Evaluation der Ergebnisse
- Zielerreichung/offene Punkte
- Ausblick, weiterführende Schritte
])

= Project Management

#emph(text(gray)[
- Vorgehen (Prozess, Reviews, Workflows, Qualitätssicherung)
- Projektplan, Vergleich ursprüngliche Planung, effektive Ausführung
- Zeiterfassung (Stunden pro Woche/Stunden pro Task-Kategorie, wie Implementation Doku, Meeting, etc.)
Hinweis: Keine Liniendiagramme für die Darstellung von Zeit/Arbeitsaufwand pro Woche
])

= Glossary

#emph(text(gray)[
  - Kurze Erklärung der projektspezifischen Begriffe und Abkürzungen
])

= Appendices

#emph(text(gray)[
- Relevante Anhänge
- Meeting Protokolle
- Vereinbarungen
- (SA/BA): Persönliche Berichte (0.5-1 Seite)
- Entwicklerdokumentation
- User Dokumentation
- Sonstige Protokolle (z.B. von Usability Tests)
])

#pagebreak()
#bibliography("bibliography.bib")

#pagebreak()
#set heading(numbering: none)

= Table of Figures
#outline(
  title: none,
  target: figure.where(kind: image),
)
