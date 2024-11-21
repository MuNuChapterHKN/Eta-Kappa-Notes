#import "funcs.typ": *
#import "@preview/equate:0.2.1": equate
#import "@preview/codly:1.0.0": *
#import "@preview/codly-languages:0.1.0": *
#import "@preview/bytefield:0.0.6": *
#import "palette.typ": hkn_blue

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

#let _template(
  title: [],
  code: "",
  subtitle: [Eta Kappa Notes],
  authors: (),
  release: "",
  lang: "en",
  show-outline: true,
  _type: "degree",
  body,
) = {
  set document(title: title, author: authors)
  set text(font: "New Computer Modern", size: 10pt, lang: lang)
  set page(paper: "a4", numbering: "1")
  set par(justify: true)

  // MATH

  show: equate.with(breakable: true, sub-numbering: true)
  set math.equation(numbering: "(1.1)")

  // FIGURES

  show figure.caption: emph

  // HEADINGS
  // TODO: https://github.com/typst/typst/issues/2814

  set heading(offset: 2)

  set heading(numbering: clean-numbering("I", "A)", "1.1"))

  show heading.where(level: 1): set heading(supplement: if lang == "en" [Course Year] else [Anno di Corso])
  show heading.where(level: 2): set heading(supplement: if lang == "en" [Course] else [Corso])
  show heading.where(level: 3): set heading(supplement: if lang == "en" [Chapter] else [Capitolo])

  show heading.where(level: 1, outlined: true): it => {
    set page(numbering: none, header: none)
    set par(justify: false)

    align(center + horizon, text(size: 2em, smallcaps(it.body)))
  }

  show heading.where(level: 2): it => block(
    width: 100%,
    height: 10%,
    {
      set align(center + horizon)
      set par(justify: false)
      if it.supplement == [] {
        set text(1.3em, weight: "bold")
        smallcaps(it)
      } else {
        let l = line(length: 100%, stroke: 0.5pt + hkn_blue)
        let course = [
          #text(weight: "regular")[
            #smallcaps(it.supplement) #code
          ]
        ]
        grid(
          columns: (1fr, auto, 1fr),
          align: horizon,
          gutter: 0.5em,
          l, course, l,
        )
        set text(1.8em, weight: "bold")
        smallcaps(it.body)
      }
    },
  )

  show heading.where(level: 3): it => {
    block(
      above: 2.2em,
      below: 2.2em,
      breakable: false,
      text(15pt, hyphenate: false, weight: "bold", smallcaps(it)),
    )
  }

  show heading.where(level: 4): it => {
    block(
      above: 2.2em,
      below: 1.5em,
      breakable: false,
      text(1.2em, hyphenate: false, weight: "bold", smallcaps(it)),
    )
  }

  // CODE

  show: codly-init
  codly(
    languages: codly-languages,
    zebra-fill: none,
    number-format: it => text(fill: luma(200), str(it)),
  )

  // TERMS

  show terms.item: it => [
    _*#it.term:*_ #it.description
  ]

  // TABLES

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

  // TITLE PAGE

  if _type == "degree" {
    title-page(title, subtitle, authors, release)
  }

  // OUTLINE

  set outline(fill: repeat[ #sym.space ⋅ ], indent: true)
  show outline.entry.where(level: if _type == "degree" {
    1
  } else {
    3
  }): it => {
    v(12pt, weak: true)
    strong(it)
  }

  if show-outline {
    if _type == "degree" {
      show: course-outline()
    } else {
      heading(level: 2)[#title #label(code)]
      show: outline(
        target: selector.or(..range(3,7).map(l => heading.where(level: l))),
        depth: 7,
      )
    }
  }

  // BODY

  body
}

#let degree-template = _template.with(_type: "degree")

#let course-template = _template.with(_type: "course")
