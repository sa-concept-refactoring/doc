#let printProgressBar(progress, fill: gray, label: "") = {
    let colorScale = (red, orange, yellow, green)
    let colorScalePosition = if progress < 0.25 {0} 
      else if progress < 0.5 {1} 
      else if progress < 0.75 {2} 
      else {3}
    set text(white, size: 8pt, )
    set align(center)
    rect(
      fill: fill,
      width: 100%,
      height: 12pt,
      inset: 0pt,
      radius: 4pt,
      [
        #set align(left)
        #rect(
          fill: colorScale.at(colorScalePosition),
          width: 100% * calc.min(progress, 1),
          height: 12pt,
          radius: 4pt,
          inset: 5pt
        )[
          #set align(horizon)
          #{label}
        ]
      ],
    )
  }