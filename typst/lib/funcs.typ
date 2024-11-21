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

#let def(definition) = [
  *_Def:_* #definition
]
