#import "../../../../../../../typst/lib/deps.typ"
#import deps.bytefield: *

#set page(width: 200mm, height: 20mm, fill: none)
#set text(font: "New Computer Modern", size: 10pt)

#bytefield(
  bitheader("bounds"),
  bits(2, fill: yellow.lighten(80%))[`10`],
  bits(14)[Network],
  bits(16)[Host],
)
