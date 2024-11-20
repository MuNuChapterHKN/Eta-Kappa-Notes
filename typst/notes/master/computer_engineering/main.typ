#import "../../../lib/template.typ": degree-template
#import "../../../lib/funcs.typ": course-outline

#show: degree-template.with(
  title: [Master in Computer Engineering],
  release: "0.1.0",
  authors: ("Eduard Antonovic Occhipinti",),
)

#course-outline()

#heading(level: 1)[First Year]

#include "computer_networks_technologies_and_services/main.typ"

#heading(level: 1)[Second Year]

