#import "@preview/bytefield:0.0.6": *

#set page(width: 200mm, height: 20mm, fill: none)
#set text(font: "New Computer Modern", size: 10pt)

#bytefield(
  bitheader("bounds"),
  bits(2, fill: yellow.lighten(80%))[`10`],
  bits(14)[Network],
  bits(16)[Host],
)
