#import "../../../../../../../typst/lib/deps.typ"
#import deps.bytefield: *

#set page(width: 200mm, height: 20mm, fill: none)
#set text(font: "New Computer Modern", size: 10pt)

#bytefield(
  bitheader("bounds"),
  bits(3, fill: yellow.lighten(80%))[`110`],
  bits(21)[Network],
  bits(8)[Host],
)
