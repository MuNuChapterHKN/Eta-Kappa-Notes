#import "funcs.typ": *

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

#let template(
  title: [],
  subtitle: [Eta Kappa Notes],
  authors: (),
  release: "",
  body,
) = {
  set document(title: title, author: authors)
  set text(font: "New Computer Modern", size: 10pt)
  set page(paper: "a4")

  set heading(numbering: clean-numbering("I", "A.", "1.a.i."))

  show heading.where(level: 1): set heading(supplement: [Chapter])

  set outline(depth: 3, indent: true)

  show terms.item: it => [
    _*#it.term:*_ #it.description
  ]

  title-page(title, subtitle, authors, release)

  set par(justify: true)

  body
}
