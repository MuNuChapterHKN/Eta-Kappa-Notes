#import "@preview/bytefield:0.0.6": *
#import "../../../../lib/template.typ": course-template

#let highlight = highlight.with(fill: yellow.lighten(80%))

#show: course-template.with(
  title: [Computer Networks Technologies and Services],
  subtitle: [IPv4 Addressing and Routing],
  release: "0.1.0",
  authors: ("Eduard Antonovic Occhipinti",),
)

= IPv4 Addressing and Routing

== IPv4 Addressing

IP addresses have the goal to be "nominally unique", that means that they should be unique in the network they are in.

IP addresses are 32 bit identifiers for the #highlight[interface], not the device. The device can have multiple interfaces, and each interface has its own IP address. For example a smartphone can have an IP address for the Wi-Fi interface and another one for the cellular interface.

=== Notation

#grid(
  columns: 2,
  align: center + bottom,
  inset: 1em,
  figure(image("res/svg/datagram.drawio.svg"), caption: "IP Datagram"),
  figure(image("res/svg/router.drawio.svg"), caption: "Router - Layer 3"),

  figure(image("res/svg/switch.drawio.svg"), caption: "Switch - Layer 2"),
  figure(image("res/svg/access_point.drawio.svg"), caption: "Access Point - Layer 2"),
)

#figure(
  bytefield(
    bitheader("bytes"),
    bits(12)[Network ID (high order bits)],
    bits(20)[Host ID (low order bits)],
  ),
  caption: "IP Address",
)

- An IP Network is a set of IP devices whose interfaces have
  - same network ID
  - a common physical connection (link-layer network)

=== Special Addresses

#grid(
  columns: 2,
  inset: 0.5em,
  align: horizon,
  bytefield(
    bits(20)[Some value],
    bits(12)[All zeros],
  ),
  [The (sub)network ID],

  bytefield(
    bits(32)[All ones],
  ),
  [#highlight[Limited]: Broadcast packet becomes a L2 packet],

  bytefield(
    bits(20)[Some value],
    bits(12)[All ones],
  ),
  [Directed broadcast for network (usually restricted)],

  bytefield(
    bitheader("bounds"),
    bits(8)[127],
    bits(24)[Anything (often ones)],
  ),
  [Loopback],
)

== Addressing Classes

#figure(
  bytefield(
    bitheader("bounds"),
    bits(1, fill: yellow.lighten(80%))[`0`],
    bits(7)[Network],
    bits(24)[Host],
  ),
  caption: [Class A - 128 networks, 16M hosts per network],
)


#figure(
  bytefield(
    bitheader("bounds"),
    bits(2, fill: yellow.lighten(80%))[`10`],
    bits(14)[Network],
    bits(16)[Host],
  ),
  caption: [Class B - 16K networks, 64K hosts per network],
)

#figure(
  bytefield(
    bitheader("bounds"),
    bits(3, fill: yellow.lighten(80%))[`110`],
    bits(21)[Network],
    bits(8)[Host],
  ),
  caption: [Class C - 2M networks, 254 hosts per network],
)

== CIDR | Classless Inter-Domain Routing

Enables the use of arbitrary length network prefixes. The network prefix is written as `a.b.c.d/x`, where `x` is the number of bits in the network prefix.

The network prefix is also referred to as the #highlight[subnet mask] or #highlight[netmask]. The netmask is a 32 bit value that has `x` bits set to 1 and the rest set to 0.

/ `200.23.16.0 / 23`: prefix length notation

/ `200.23.16.0   255.255.254.0`: netmask notation

=== Table of Valid Netmask

#table(
  columns: 3,
  table.header([Netmask], [#text(hyphenate: false)[Prefix]], [Number of Usable IDs]),
  [`255.255.255.0`], [`/24`], [254],
  [`255.255.255.128`], [`/25`], [126],
  [`255.255.255.192`], [`/26`], [62],
  [`255.255.255.224`], [`/27`], [30],
  [`255.255.255.240`], [`/28`], [14],
  [`255.255.255.248`], [`/29`], [6],
  [`255.255.255.252`], [`/30`], [2 #highlight(fill: green.lighten(80%))[Smallest usable netmask]],
  [`255.255.255.254`], [`/31`], [#highlight(fill: red.lighten(80%))[Useless]],
  [`255.255.255.255`], [`/32`], [#highlight[Represents the single device]],
)
