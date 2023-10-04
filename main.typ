#include "title-page.typ"

#show raw: it => block(
  fill: luma(0xF0),
  inset: 8pt,
  radius: 5pt,
  text(it)
)

#set page(numbering: "1 / 1")

= Abstract
TODO

// Der Abstract richtet sich an den Spezialisten auf dem entsprechenden Gebiet und beschreibt
// daher in erster Linie die (neuen, eigenen) Ergebnisse und Resultate der Arbeit. (Aus
// Anleitung Dokumentation FS21 vom SG-I).
// - Der Umfang beträgt in der Regel eine halbe Seite Text
// - Keine Bilder

= Management Summary

// - Das Management Summary richtet sich in der Praxis an die "Chefs des Chefs", d.h. an die
// Vorgesetzten des Auftraggebers (diese sind in der Regel keine Fachspezialisten). Die Sprache
// soll knapp, klar und stark untergliedert sein. (Aus Anleitung Dokumentation FS21 vom SG-I)
// - Der Umfang beträgt in der Regel 3-5 Seiten.
// - Bilder sind hier sinnvoll

#pagebreak()

#outline(
  title: "Table of Contents",
  indent: auto,
)

#pagebreak()

#set heading(numbering: "1.")

= Methods
Development work occurred on both Linux and Windows utilizing CLion with the Ninja build system.
The language server features were tested using Visual Studio Code and the clangd extension.

= Existing Language Server Features

We did not find any specific language server features related to concepts.
Some basics like symbol rename seem to work well though.


= Introduction

// - Beschreibung der Ausgangslage
// - Beschreibung der Aufgabe
// - Rahmenbedingungen
// - Vorarbeiten
// - Übersicht über die kommende Kapitel

== Initial Situation
#link("https://github.com/llvm/llvm-project")[LLVM project] is an open source repository on GitHub and contains the source code for LLVM, a toolkit for the construction of highly optimized compilers, optimizers, and run-time environments. 

== Problem Description
As of the new changes of C++20 type constraints were introduced. 
For this new added feature not many refactoring options do currently exist which should be changed with our SA.

== Project Goal
The goal of this project is to contribute a refactoring feature to the LLVM project, for the newly added type constraints for C++.

=== Ideas

==== Transformation of Concept Usage

A new refactoring could be provided to transform a function template using concepts between alternate forms.
@transformation_idea_listing shows the different forms.

#figure(
  grid(
    columns: (auto, auto),
    gutter: 1em,
    align(start + horizon)[
      ```cpp
      template<Hashable T>
      void f(T) {}
      ```
    ],
    align(start + horizon)[
      ```cpp
      template<typename T>
      void f(T) requires Hashable<T> {}
      ```
    ],
    align(start + horizon)[
      ```cpp
      void f(Hashable auto x) {}
      ```
    ],
    align(start + horizon)[
      ```cpp
      template<typename T> requires Hashable<T>
      void f(T) {}
      ```
    ],
  ),
  caption: [
    Different ways to constrain a function template using concepts
  ],
) <transformation_idea_listing>

#pagebreak()


== Structure of This Report
This report describes the analysis, elaboration and implementation of the work. The document is divided into the following parts:

// TODO descibe chapers

= Analysis

// - Beschreibung des System-Kontexts
// - Funktionale und nicht-Funktionale Anforderungen
// - Use Cases/Scenarios/User Storys
// - Bestehende Infrastruktur
// - Abhängig vom Projekt: Risikoanalyse
// - Beschreibung (externen) existierenden Schnittstellen

= Design

// - Beschreibung des Entwurfs der Lösung
// - Architektur-Übersicht (Anmerkung das C4-Modell gibt eine gute Abstufung der Details)
// - Internes Design (Subsysteme, Komponenten, Klassen)
// - Extenes Design (UI)
// - Entscheidungen: Alternativen erklären und Entscheidung nachvollziehbar begründen

= Implementation

// - Beschreibung interessanter Implementationsaspekte
// - Verwendete Technologien
// - Nebenläufigkeit
// - Vorgehen beim Testing

= Resultate

// - Zielerreichung
// - Auswertung Erfüllung der Anforderungen
// - Projektmetriken

= Conclusion

// - Zusammenfassung
// - Evaluation der Ergebnisse
// - Zielerreichung/offene Punkte
// - Ausblick, weiterführende Schritte

= Project Management

// - Vorgehen (Prozess, Reviews, Workflows, Qualitätssicherung)
// - Projektplan, Vergleich ursprüngliche Planung, effektive Ausführung
// - Zeiterfassung (Stunden pro Woche/Stunden pro Task-Kategorie, wie Implementation Doku, Meeting, etc.)
// Hinweis: Keine Liniendiagramme für die Darstellung von Zeit/Arbeitsaufwand pro Woche

#pagebreak()
#set heading(numbering: none)

= Disclaimer
Parts of this paper were rephrased by GPT-3.5.

#pagebreak()

= Glossary
/ SA: Abbreviation for Semester-Arbeit. \ The term is used in the German academic context to refer to a Semester Project.

#pagebreak()

#bibliography("bibliography.bib")

#pagebreak()

= Table of Figures
#outline(
  title: none,
  target: figure.where(kind: image),
)

#pagebreak()

= List of Listings
#outline(
  title: none,
  target: figure.where(kind: raw),
)

#pagebreak()

= Appendices

// - Relevante Anhänge
// - Meeting Protokolle
// - Vereinbarungen
// - (SA/BA): Persönliche Berichte (0.5-1 Seite)
// - Entwicklerdokumentation
// - User Dokumentation
// - Sonstige Protokolle (z.B. von Usability Tests)
