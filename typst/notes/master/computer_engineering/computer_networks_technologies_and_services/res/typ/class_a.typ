#import "../../../../../../../typst/lib/deps.typ"
#import deps.bytefield: *

#set page(width: 200mm, height: 20mm, fill: none)
#set text(font: "New Computer Modern", size: 10pt)

#bytefield(
  bitheader("bounds"),
  bits(1, fill: yellow.lighten(80%))[`0`],
  bits(7)[Network],
  bits(24)[Host],
)
