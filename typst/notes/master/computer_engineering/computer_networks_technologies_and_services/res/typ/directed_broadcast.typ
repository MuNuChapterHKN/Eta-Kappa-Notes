#import "@preview/bytefield:0.0.6": *

#set page(width: 200mm, height: 12mm, fill: none)
#set text(font: "New Computer Modern", size: 10pt)

#bytefield(
  bits(20)[Some value],
  bits(12)[All ones],
)

