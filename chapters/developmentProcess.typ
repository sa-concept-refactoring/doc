= Development Process <development_process>

To achieve this refactoring the whole function needs to be checked for usages of the defined template type parameters

== Workflow

#figure(
  image("../drawio/project-organisation.drawio.svg", width: 100%),
  caption: [
    diagram showing structure and workflow of the project
  ],
)

=== Git
To make life easier it was decided to create a repository on Github and make the whole work open source. 
As there was an already existing pipeline from the original llvm project it self the decision came rather quick as otherwise there could have popped up a lot of different problems and issues.

== Setup
To build clangd, CLion was used as an IDE since it has great support for CMake as well as very good autocomplete, search and debugging capabilities.
VS Code with the clangd extension @clangd_extension and cmake extension @cmake_extension was then configured to use the locally built language server using the `clangd.path` setting.

*`settings.json`:*
```cpp
{
    // Windows
    "clangd.path": "..\\llvm-project\\llvm\\cmake-build-release\\bin\\clangd.exe"

    // Linux
    "clangd.path": "../llvm-project/llvm/cmake-build-release/bin/clangd"
}
```

*Building Clangd in CLion:*
+ Clone project from GitHub https://github.com/llvm/llvm-project
	- `git clone git@github.com:llvm/llvm-project.git`
+ Open llvm project in CLion
+ Open folder `llvm/CMake.txt` in CLion and execute cmake
+ File -> Settings -> Build, Execution, Deployment -> CMake -> CMake options
	- add `-DLLVM_ENABLE_PROJECTS='clang;clang-tools-extra'`
+ Choose "clangd" in target selector and start building

After the clangd build is completed the language server within VS Code needs to be restarted to use the current build.
+ Ctrl. + p : `>Restart language Server`


_Note:_ When using Windows, clangd.exe should not be in use to build clangd successfully.
In this example this applies to VSCode when the language server has started.

=== Windows

The project was built using ninja and Visual Studio.

The Visual Studio was installed with the following components:
- C++ ATL for latest v143 build tools
- Security Issue Analysis
- C++ Build Insights
- Just-In-Time debugger
- C++ profiling tools
- C++ CMake tools for Windows
- Test Adapter for Boost.Test 
- Test Adapter for Google Test
- Live Share
- IntelliCode
- C++ AddressSanitizer
- Windows 11 SDK
- vcpkg package manager

The hardwae used was a Intel(R) Core(TM) i7-10510U CPU with 16 gigabytes of system memory.

#figure(
  image("../images/screenshot_build_options_windows.png", width: 100%),
  caption: [
    screenshot showing build settings in CLion on Windows
  ],
)

=== Linux

The project was built using ninja and gcc12.
Tests with the language server were performed using VSCodium @VSCodium, a fork of VS Code without telemetry. \

The hardware used was a AMD Ryzen™ PRO 4750U (8 core mobile) and a AMD Ryzen™ 9 5900X (12 core desktop) CPU with 48 gigabytes of system memory.

= Project Management
// - Vorgehen (Prozess, Reviews, Workflows, Qualitätssicherung)
// - Projektplan, Vergleich ursprüngliche Planung, effektive Ausführung
// - Zeiterfassung (Stunden pro Woche/Stunden pro Task-Kategorie, wie Implementation Doku, Meeting, etc.)
// Hinweis: Keine Liniendiagramme für die Darstellung von Zeit/Arbeitsaufwand pro Woche

== Methods
Development work occurred on both Linux and Windows utilizing CLion with the Ninja build system.
The language server features were tested using Visual Studio Code and the clangd extension.

#set page(flipped: true)

== Project Plan
Due to the absence of detailed guidelines, we can only offer a rough plan at this time.

#let numberOfWeeks = 15

// #figure(
//   box(
//     width: 100%,
//     tablex(
//       header: 1,
//       columns: range(1, numberOfWeeks + 1).map(_ => 1fr),
//       align: center + horizon,
//       map-rows: (row, cells) => cells.map(c =>
//         if c == none {
//           c
//         } else {
//           (..c, fill: if row == 0 { aqua })
//         }
//       ),
//       /* --- header --- */
//       ..range(1, numberOfWeeks + 1).map(w => strong("w" + str(w))),
//       /* ------------- */
//       [Setup], colspanx(3)[1. refactoring feature], colspanx(2)[optimization & testing], colspanx(2)[contribute to LLVM], colspanx(3, fill:blue)[], colspanx(2)[finish documentation], [hand in], [Apéro],
//       /* ------------- */
//       colspanx(6)[], colspanx(5)[2. refactoring feature], colspanx(4)[]
//     )
//   ),
//   caption: [ Project plan ],
// )

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
    (2, "Implemenatation"),
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
    (2, "Implemenatation"),
    (2, "Refinement"),
    (2, "Pull Request"),
  ),
)

#pagebreak()
#set page(flipped: false)

== Time Tracking
To monitor our working hours effectively, we have established a straightforward Google Sheet where we meticulously record information about our tasks, such as who is assigned to them, the task's nature, and the duration spent on each task. Additionally, each entry includes a brief comment detailing the specific work performed during that time.

// TODO small summary of time tracking