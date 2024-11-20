#import "@preview/bytefield:0.0.6": *

#set page(width: 200mm, height: 20mm, fill: none)
#set text(font: "New Computer Modern", size: 10pt)

#bytefield(
  bitheader("bytes"),
  bits(12)[Network ID (high order bits)],
  bits(20)[Host ID (low order bits)],
)

