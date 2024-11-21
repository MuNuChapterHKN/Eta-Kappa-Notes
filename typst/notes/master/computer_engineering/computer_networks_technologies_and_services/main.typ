#import "@preview/bytefield:0.0.6": *
#import "../../../../lib/template.typ": course-template

#let bytefield = bytefield.with(stroke: 0.5pt)

#let hl = highlight.with(fill: yellow.lighten(80%))
#let hl_green = highlight.with(fill: green.lighten(80%))
#let hl_reed = highlight.with(fill: red.lighten(80%))

#show: course-template.with(
  title: [Computer Networks Technologies and Services],
  code: "01OTWOV",
  subtitle: [IPv4 Addressing and Routing],
  release: "0.1.0",
  authors: ("Eduard Antonovic Occhipinti",),
)

= IPv4 Addressing and Routing

== IPv4 Addressing

IP addresses have the goal to be "nominally unique", that means that they should be unique in the network they are in.

IP addresses are 32 bit identifiers for the #hl[interface], #underline[not the device]. The device can have multiple interfaces, and each interface has its own IP address. For example a smartphone can have an IP address for the Wi-Fi interface and another one for the cellular interface. It's a Layer 3 protocol.

=== Notation

#grid(
  columns: 2,
  align: center + bottom,
  inset: 1em,
  figure(image("res/svg/datagram.drawio.svg"), caption: [IP Datagram]),
  figure(image("res/svg/router.drawio.svg"), caption: [Router - Layer 3, routes packets between networks]),

  figure(
    image("res/svg/switch.drawio.svg"),
    caption: [Switch - Layer 2, interconnects devices. It's "transparent", it doesn't have an IP address],
  ),
  figure(image("res/svg/access_point.drawio.svg"), caption: [Access Point - Layer 2]),
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
  [/ The (sub)network ID: not to be confused with the interface ID],

  bytefield(
    bits(32)[All ones],
  ),
  [/ Limited broadcast (local net): Broadcast packet becomes a L2 packet. It's received by #underline[all] devices on the same network],

  bytefield(
    bits(20)[Some value],
    bits(12)[All ones],
  ),
  [/ Directed broadcast for network: (usually restricted). It implies that everyone on another network receives the packet],

  bytefield(
    bitheader("bounds"),
    bits(8)[127],
    bits(24)[Anything (often ones)],
  ),
  [/ Loopback: the packet is sent back to the interface that sent it],
)

== Addressing Classes

#grid(
  columns: 2,
  inset: 0.5em,
  align: horizon,
  figure(
    bytefield(
      bitheader("bounds"),
      bits(1, fill: yellow.lighten(80%))[`0`],
      bits(7)[Network],
      bits(24)[Host],
    ),
    caption: [Class A - 128 networks, 16M hosts per network],
  ),
  [We ran out of Class A addresses quickly due to big enterprises and most of the Host addresses are wasted.],

  figure(
    bytefield(
      bitheader("bounds"),
      bits(2, fill: yellow.lighten(80%))[`10`],
      bits(14)[Network],
      bits(16)[Host],
    ),
    caption: [Class B - 16K networks, 64K hosts per network],
  ),
  [Same problem as Class A but it took longer to run out of addresses.],

  figure(
    bytefield(
      bitheader("bounds"),
      bits(3, fill: yellow.lighten(80%))[`110`],
      bits(21)[Network],
      bits(8)[Host],
    ),
    caption: [Class C - 2M networks, 254 hosts per network],
  ),
  [The small number of hosts per network is a problem for big enterprises. So we have to use multiple Class C networks.],
)

We will look at class D in @ipv4multicast. Class E also exists but we won't cover it in this course.

== CIDR | Classless Inter-Domain Routing

It's sort of a patch to the problem of the address space exhaustion.

Enables the use of arbitrary length network prefixes. The network prefix is written as `a.b.c.d/x`, where `x` is the number of bits in the network prefix.

The network prefix is also referred to as the #hl[subnet mask] or #hl[netmask]. The netmask is a 32 bit value that has `x` bits set to 1 and the rest set to 0.

/ `200.23.16.0 / 23`: prefix length notation

/ `200.23.16.0   255.255.254.0`: netmask notation

=== Table of Valid Netmask

#figure(
  table(
    columns: 3,
    table.header([Netmask], [#text(hyphenate: false)[Prefix]], [Number of Usable IDs]),
    [`255.255.255.0`], [`/24`], [254],
    [`255.255.255.128`], [`/25`], [126],
    [`255.255.255.192`], [`/26`], [62],
    [`255.255.255.224`], [`/27`], [30],
    [`255.255.255.240`], [`/28`], [14],
    [`255.255.255.248`], [`/29`], [6],
    [`255.255.255.252`], [`/30`], [2 #hl(fill: green.lighten(80%))[Smallest usable netmask]],
    [`255.255.255.254`], [`/31`], [#hl(fill: red.lighten(80%))[Useless]],
    [`255.255.255.255`], [`/32`], [#hl[Represents the single device]],
  ),
)

== IP Routing

Routing is the process of selecting the (best) path for a packet to reach its destination.

/ Routing table: specifies the next hop for each destination network.

/ Hop: is the act of traversing the router.

- An IP device searches its own routing table
- The most specific prefix is selected for the match (#hl[longest prefix matching])

#figure(
  table(
    columns: 2,
    table.header([Destination], [Output Link]),
    [`200.23.16.0/20`], [1],
    [`200.23.18.0/23`], [2],
    [`199.31.0.0/16`], [2],
  ),
  caption: [Routing Table],
) <routing-table>

For example in @routing-table an address `199.31.2.7` the device would first check if the first 20 bits are #underline[identical]. We immediately notice that the first two destinations are a no match, given that the first byte of each is already different. The third destination is a match, because we have:

#figure(
  bytefield(
    bitheader(0, 7, 15, text(hyphenate: false)[prefix], 23, 31),
    note(left)[Packet IP Address],
    bits(8, fill: green.lighten(80%))[199],
    bits(8, fill: green.lighten(80%))[31],
    bits(8)[2],
    bits(8)[7],
    note(right)[Destination IP Address],
    bits(8, fill: green.lighten(80%))[199],
    bits(8, fill: green.lighten(80%))[31],
    bits(8)[0],
    bits(8)[0],
  ),
  caption: [Longest Prefix Matching, in green we highlight the matching bits],
)

Suppose now that we receive `200.23.19.190`, the first destination does match, but the router will choose the second destination because it's more specific. It has a longer match.

#figure(
  bytefield(
    bitheader(0, 7, 15, 19, text(hyphenate: false)[prefix \#1], 22, text(hyphenate: false)[prefix \#2], 31),
    note(left)[Packet IP Address],
    bits(8, fill: green.lighten(80%))[200],
    bits(8, fill: green.lighten(80%))[23],
    bits(7, fill: green.lighten(80%))[`0001 001`],
    bits(1)[`1`],
    bits(8)[190],
    note(right)[Destination IP Address \#1],
    bits(8, fill: yellow.lighten(80%))[200],
    bits(8, fill: yellow.lighten(80%))[23],
    bits(4, fill: yellow.lighten(80%))[`0001`],
    bits(4)[`0000`],
    bits(8)[0],
    note(right)[Destination IP Address \#2],
    bits(8, fill: green.lighten(80%))[200],
    bits(8, fill: green.lighten(80%))[23],
    bits(7, fill: green.lighten(80%))[`0001 001`],
    bits(1)[`0`],
    bits(8)[0],
  ),
  caption: [Longest Prefix Matching, as we can see, the second destination has a longer match. Matching bits are highlighted, in yellow the matches that are discarded],
)

=== Case destination with IP address that is included in another destination

Suppose we have a new destination in output link 1 with the IP address `200.23.18.26`. Every packet sent to this address would match the second destination, to avoid this we have to add to the routing table the address `200.23.18.26/32` with output link 1. This way we force packets to go to the exact destination.

== IPv4 Multicast <ipv4multicast>

Multicast is a procedure by which one source can send one IP packet to multiple destinations.

- A multicast address identifies a group of hosts.

#grid(
  columns: 2,
  inset: 0.5em,
  align: horizon,
  figure(
    bytefield(
      bitheader("bounds"),
      bits(4, fill: yellow.lighten(80%))[`1110`],
      bits(28)[Network],
    ),
    caption: [Class D - 268M multicast groups],
  ),
  [The multicast address is in the range `224.0.0.0` to `239.255.255.255`. Notice that there is no host address, because the multicast address identifies a #underline[host group].],
)

Packets are delivered to all hosts that are part of the multicast group. That means potentially anyone connected to internet. This is a security problem.

=== Host Group Membership

- Hosts can join or leave a multicast group at any time.
- Recipients establish which hosts receive the packet.

/ IGMP (Internet Group Management Protocol): is a protocol (i.e. encapsulated in IPv4 datagrams) that is used by routers and hosts to handle memberships.

== Traffic in a Local Area Network (LAN) (IEE 802)

- The router will delegate the delivery to Layer 2 (MAC).

=== MAC Address

- 48 bit identifier for the interface.
- Usually written in six pairs of hexadecimal numbers.

Like for IP addresses, MAC addresses have a range of special addresses reserved for multicast. In particular the first 25 bits are set to `01-00-5E-0`.

To map a multicast IPv4 address to a multicast MAC address we map the 23 least significant bits of the IPv4 address to the 23 least significant bits of the MAC address.

#figure(
  [
    #grid(
      columns: 2,
      [#h(150pt)],
      bytefield(
        bitheader("bounds"),
        bits(4)[`1110`],
        bits(5)[],
        bits(23, fill: blue.lighten(80%))[],
      ),
    )

    #bytefield(
      bpr: 48,
      bitheader("bounds"),
      bits(25)[`01-00-5E-0`],
      bits(23, fill: blue.lighten(80%))[],
    )
  ],
  caption: [Mapping IPv4 Multicast Address to MAC Address, the bits that are carried over are highlighted in blue],
)

1. The router recognizes a multicast packet and, before sending it to the switch, it encapsulates it in an ethernet packet with destination being the MAC derived from the multicast IP address.
2. This ethernet packet is sent to the switch, which will recognize the multicast MAC and broadcasts only to specific hosts that are subscribed to the multicast group. This is done by the switches through a function called *IGMP snooping*.
  - Switches are L2 so normally they would not be able to read the IGMP join packets.
  - The alternative is having the router send the multicast traffic on the layer 2 multicast address. That means sensing a packet with MAC address `FF-FF-FF-FF-FF-FF` to all hosts in the network. The host will then decide if the packet is for them or not.
3. The hosts will recognize the packet as belonging to a multicast group they are subscribed to through IGMP. When the MAC address is passed to Layer 3 the IP Multicast address will be recognized.

This way we avoid broadcasting packets to all hosts in the network.

== Beyond Local Area Networks

We have router that discover host groups on each LAN using IGMP, announce host groups to the others and build a distribution tree for each host group.

This type of technology is not widely supported and not always fit for the purpose.
