#import "../../../../../../../typst/lib/deps.typ"
#import deps.bytefield: *

#set page(width: 200mm, height: 12mm, fill: none)
#set text(font: "New Computer Modern", size: 10pt)

#bytefield(
  bits(20)[Some value],
  bits(12)[All ones],
)

