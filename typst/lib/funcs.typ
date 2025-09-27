#import "deps.typ"
#import deps.cetz
#import deps.gentle-clues: *

#let polygon(
  ..args,
  num-vertices: 6,
  center: (1, 1),
  radius: 1,
  orientation: "flat-top",
) = {
  let angle = 2 * calc.pi / num-vertices
  let points = range(0, num-vertices).map(i => {
    let x = center.first() + radius * calc.cos(i * angle)
    let y = center.last() + radius * calc.sin(i * angle)
    (x, y)
  })

  points.push(points.first())

  cetz.draw.line(..points, ..args)
}

#let hexagon = polygon.with(num-vertices: 6)

#let honeycomb(
  columns: auto,
  rows: auto,
  radius: auto,
  custom-args-map: ((auto, (auto,)),),
  ..line-args,
) = {
  let centers = range(0, rows).map(row => {
    range(0, columns).map(column => {
      let x = radius * 3 / 2 * column
      let y = radius * calc.sqrt(3) * (row + calc.rem(column, 2) / 2)
      (x, -y)
    })
  })

  let hex-count = 0
  for row in centers {
    for center in row {
      let args = custom-args-map.find(mapping => mapping.at(0) == hex-count)

      if args != none {
        hexagon(
          center: center,
          radius: radius,
          ..line-args,
          ..args.at(1),
        )
      } else {
        hexagon(center: center, radius: radius, ..line-args)
      }
      hex-count += 1
    }
  }
}

#let clean-numbering(..schemes) = {
  (..nums) => {
    let (section, ..subsections) = nums.pos()
    let (section_scheme, ..subschemes) = schemes.pos()

    if subsections.len() == 0 {
      numbering(section_scheme, section)
    } else if subschemes.len() == 0 {
      numbering(section_scheme, ..nums.pos())
    } else {
      clean-numbering(..subschemes)(..subsections)
    }
  }
}

#let course-outline() = {
  outline(
    title: "Indice Italiano",
    target: selector(
      heading.where(outlined: true, supplement: [Sezione]).or(
        heading.where(outlined: true, supplement: [Capitolo]).or(
          heading.where(outlined: true, supplement: [Corso]).or(
            heading.where(outlined: true, supplement: [Anno di Corso]),
          ),
        ),
      ),
    ),
    depth: 2,
  )

  outline(
    title: "English Index",
    target: selector(
      heading.where(outlined: true, supplement: [Section]).or(
        heading.where(outlined: true, supplement: [Chapter]).or(
          heading.where(outlined: true, supplement: [Course]).or(
            heading.where(outlined: true, supplement: [Course Year]),
          ),
        ),
      ),
    ),
    depth: 2,
  )
}

#let def = quotation.with(title: context if text.lang == "en" [Definition] else [Definizione])
