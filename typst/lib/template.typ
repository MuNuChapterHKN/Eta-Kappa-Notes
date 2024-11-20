#import "funcs.typ": *
#import "@preview/equate:0.2.1": equate
#import "@preview/codly:1.0.0": *
#import "@preview/codly-languages:0.1.0": *

#let title-page(title, subtitle, authors, release) = {
  set align(center)

  v(1fr)

  figure(image("../../resources/imgs/hkn_logo.svg", width: 40%))

  smallcaps(text(weight: "bold", size: 2em, title))

  line(length: 100%)

  smallcaps(text(size: 1.5em, subtitle))

  v(1fr)

  text(size: 1em, [_Curated by_ \ \ ])
  for author in authors {
    text(size: 1em, [#author \ ])
  }

  v(1fr)

  pagebreak()
}

#let degree-template(
  title: [],
  subtitle: [Eta Kappa Notes],
  authors: (),
  release: "",
  body,
) = {
  set document(title: title, author: authors)
  set text(font: "New Computer Modern", size: 10pt)
  set page(paper: "a4")
  show: equate.with(breakable: true, sub-numbering: true)
  set math.equation(numbering: "(1.1)")

  set heading(numbering: clean-numbering("I", "A.", "1.a.i."))

  show heading.where(level: 1): set heading(supplement: [Chapter])
  show: codly-init
  codly(languages: codly-languages, zebra-fill: none, number-format: it => text(fill: luma(200), str(it)))
  set outline(depth: 3, indent: true)

  show terms.item: it => [
    _*#it.term:*_ #it.description
  ]

  show table.cell.where(y: 0): strong
  set table(
    stroke: (x, y) => if y == 0 {
      (bottom: 0.7pt + black)
    },
    align: (x, y) => (
      if x > 0 {
        center
      } else {
        left
      }
    ),
  )

  title-page(title, subtitle, authors, release)

  set par(justify: true)

  set heading(offset: 1)

  set outline(fill: repeat[ #sym.space ⋅ ])


  body
}

#let course-template(
  title: [],
  subtitle: [],
  authors: (),
  release: "",
  body,
) = {
  // TODO: implement custom for course-template
  set document(title: title, author: authors)
  set text(font: "New Computer Modern", size: 10pt)
  set page(paper: "a4")
  show: equate.with(breakable: true, sub-numbering: true)
  set math.equation(numbering: "(1.1)")

  // set heading(numbering: clean-numbering("I", "A.", "1.a.i."))
  set heading(numbering: "1.1")

  show heading.where(level: 1): set heading(supplement: [Chapter])
  show: codly-init
  codly(languages: codly-languages, zebra-fill: none, number-format: it => text(fill: luma(200), str(it)))
  set outline(depth: 3, indent: true)

  show terms.item: it => [
    _*#it.term:*_ #it.description
  ]

  show table.cell.where(y: 0): strong
  set table(
    stroke: (x, y) => if y == 0 {
      (bottom: 0.7pt + black)
    },
    align: (x, y) => (
      if x > 0 {
        center
      } else {
        left
      }
    ),
  )

  set par(justify: true)

  set outline(fill: repeat[ #sym.space ⋅ ])

  outline()

  body
}

