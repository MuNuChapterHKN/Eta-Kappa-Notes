#import "@preview/bytefield:0.0.6": *
#import "../../../../lib/template.typ": course-template
#import "@preview/gentle-clues:1.0.0": *
#import "@preview/fletcher:0.5.2" as fletcher: diagram, node, edge


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

IP addresses are assigned by IANA, IANA assign blocks of `/8` (see @cidr) to each Regional Internet Registry (RIR):

- AFRINIC - Africa
- APNIC - East Asia, Australia and Oceania
- ARIN - USA, Canada and some Caribbean Islands
- LACNIC - Latin America and the Caribbean
- RIPE NCC - Europe, Russia, Middle East and Central Asia

RIRs are then split into smaller blocks and assigned first to the National Internet Registries (NIRs) and afterward to the Local Internet Registries (LIRs).

== Address Pool status

Any address can be in one of five states:

- *reserved* for special use
- *unallocated* by IANA
- *unassigned* by a RIR
- *unadvertised* (but assigned) through BGP by an end user
- *advertised* by BGP

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

== Addressing Classes <address-classes>

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

We will look at class D in @ipv4multicast. Class E also exists but is reserved for future use.

== CIDR | Classless Inter-Domain Routing <cidr>

CIDR is sort of a patch to the problem of the address space exhaustion.

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

=== Routing Tables scalability

With the growth of the internet, routing tables become longer. Scaling down a network to re-assign some of its addresses leads to more complicated routing tables.

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

=== MAC Address <mac-address>

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

1. The router recognizes a multicast packet and, before sending it to the switch, it encapsulates it in an Ethernet packet with destination being the MAC derived from the multicast IP address.
2. This Ethernet packet is sent to the switch, which will recognize the multicast MAC and broadcasts only to specific hosts that are subscribed to the multicast group. This is done by the switches through a function called *IGMP snooping*.
  - Switches are L2 so normally they would not be able to read the IGMP join packets.
  - The alternative is having the router send the multicast traffic on the layer 2 multicast address. That means sensing a packet with MAC address `FF-FF-FF-FF-FF-FF` to all hosts in the network. The host will then decide if the packet is for them or not.
3. The hosts will recognize the packet as belonging to a multicast group they are subscribed to through IGMP. When the MAC address is passed to Layer 3 the IP Multicast address will be recognized.

This way we avoid broadcasting packets to all hosts in the network.

== Beyond Local Area Networks

We have router that discover host groups on each LAN using IGMP, announce host groups to the others and build a distribution tree for each host group.

This type of technology is not widely supported and not always fit for the purpose.

== NAT44 <nat44>

NAT is a software layer on top of the router that works by replacing the private IPv4 address of the sender with its own public IPv4 address. This is done because you have no guarantee that private addresses are unique outside the network. To receive the packet and discriminate between its hosts, the router uses the port number. The port number is chosen randomly by the host (Layer 4). The router keeps a table of the port numbers and the private addresses.

In mobile connections, a Carrier Grade NAT (CGN) or Large Scale NAT (LSN) is used to assign a private IPv4 address to the device.

=== NAT444 <nat444>

Consists in passing through two layers of NAT44s, a first one where the host private address is replaced with the router's private IPv4 address and a second one where the router's private IPv4 address is replaced with the LSN/CGN's public IPv4 address.

= IPv6

- 128 bit addresses ($approx 340$ undecillion addresses, so no risk of running out of addresses)

Originally from 1992, it tries to solve the lack of IP addresses of IPv4. There was the need to for a *larger address space*.

Other problem IPv6 is meant to solve are:
- *LAN Efficiency*: a greater integration between layer 2 and 3, in IPv4 multicast there is no way to control how far the protocol can reach. Also, you need support from the router, you need an additional protocol (IGMP) and you need to support it in the switches (IGMP snooping).
- *Multicast and Anycast*
- *Security*: in IPv4 there is no authentication, no encryption
- *Policy routing*: originally paths were based only on topology (i.e. strictly shortest path), with the growth of the internet shortest path is not always associated with the most cost-effective path.
- *Plug and Play*: we want to plug a device in to the network and have it immediately receive an IP address. In IPv4 you had to configure the netmask, the DNS, the gateway, etc.
- *Traffic differentiation*: to assign for example different priorities for different packets.
- *Mobility*: for cellular connection
- *Quality of Service support*

All of these features have been backported to IPv4, but they had to be implemented through additional protocols.

At the moment IPv4 and IPv6 #underline[coexist], when IPv6 reached production status, IPv4 was already deeply ingrained in the infrastructure.

== Notation

They are written in hexadecimal in group of 2 bytes separated by colons.

For example `1080:0000:0000:0007:0200:A00C:3423:A089`.

1. Leading zeros in each group can be omitted.
  - `1080:0:0:7:200:A00C:3423:A089`
2. A #underline[single] sequence of consecutive groups of zeros can be replaced by `::`. This substitution can be applied only once because having multiple "`::`" would make the address ambiguous.
  - `1080::7:200:A00C:3423:A089`

== Routing & Addressing

The same routing principles of IPv4 are use, with networks divided in groups (subnets). IPv6 calls physical networks (subnetworks) "links". We still have routers and routing tables (with IPv6 addresses in them).

- *On-link* hosts have the same prefix and can communicate directly.
- *Off-link* hosts have different prefix and need a router to communicate.

=== Address structure

#grid(
  columns: 2,
  inset: 0.5em,
  align: horizon,
  bytefield(
    bpr: 128,
    bits(64)[Prefix of n bits],
    bits(64)[Interface ID],
  ),
  [Usually the prefix is 64 bits long (often subdivided in 48 bits of "site address" and 16 bits of "subnet address") ],
)

=== Prefix

The prefix replaces the address/netmask pair in IPv6.

Written as `FEDC:0123:8700::100/48` where the `/48` is the prefix length.

No address classes (see @address-classes).

=== Address space summarized

IP Addresses are organized in three main groups:

/ Unicast: one-to-one communication

/ Multicast: one-to-many communication

/ Anycast: one-to-nearest communication, an idea that never came to fruition.

#figure(
  grid(
    columns: 2,
    column-gutter: -4em,
    align: horizon,
    diagram(
      spacing: (120pt, 10pt),
      node-stroke: 0.5pt,
      {
        let (
          ipv6-addresses,
          unicast,
          anycast,
          multicast,
          well-known,
          transient,
          solicited-node,
          global-unicast,
          link-local,
          loopback,
          unspecified,
          unique-local,
          embedded-ipv4,
        ) = (
          (0.5, -1),
          (0.5, 1),
          (0.5, -3),
          (1.1, -1),
          (1.5, 1),
          (1.5, 2),
          (1.5, 3),
          (1, 4),
          (1, 5),
          (1, 6),
          (1, 7),
          (1, 8),
          (1, 9),
        )

        node(ipv6-addresses, [IPv6 Addresses], width: 100pt)

        node(unicast, [Unicast \ (@unicast)], width: 100pt, fill: green.lighten(80%))
        node(multicast, [Multicast \ (@multicast)], width: 100pt, fill: blue.lighten(80%))
        node(anycast, [Anycast \ (@anycast)], width: 100pt, fill: yellow.lighten(80%))

        node(well-known, [Well-Known \ *`FF00::/12`*], width: 140pt, fill: blue.lighten(95%))
        node(transient, [Transient \ *`FF10::/12`*], width: 140pt, fill: blue.lighten(95%))
        node(solicited-node, [Solicited-Node \ *`FF02:0:0:0:0:1:FF00::/104`*], width: 140pt, fill: blue.lighten(95%))

        node(global-unicast, [Global Unicast \ *`2000::/3`*], width: 100pt, fill: green.lighten(95%))
        node(link-local, [Link-Local \ *`FE80::/10`*], width: 100pt, fill: green.lighten(95%))
        node(loopback, [Loopback \ *`::1/128`*], width: 100pt, fill: green.lighten(95%))
        node(unspecified, [Unspecified \ *`::/128`*], width: 100pt, fill: green.lighten(95%))
        node(unique-local, [Unique Local \ *`FC00::/7`*], width: 100pt, fill: green.lighten(95%))
        node(embedded-ipv4, [Embedded IPv4 \ *`::/80`*], width: 100pt, fill: green.lighten(95%))

        edge(ipv6-addresses, unicast, "-")
        edge(ipv6-addresses, multicast, "-")
        edge(ipv6-addresses, anycast, "-")

        edge(unicast, (unicast.first(), global-unicast.last()), global-unicast, "-")
        edge(unicast, (unicast.first(), link-local.last()), link-local, "-")
        edge(unicast, (unicast.first(), loopback.last()), loopback, "-")
        edge(unicast, (unicast.first(), unspecified.last()), unspecified, "-")
        edge(unicast, (unicast.first(), unique-local.last()), unique-local, "-")
        edge(unicast, (unicast.first(), embedded-ipv4.last()), embedded-ipv4, "-")

        edge(multicast, (multicast.first(), well-known.last()), well-known, "-")
        edge(multicast, (multicast.first(), transient.last()), transient, "-")
        edge(multicast, (multicast.first(), solicited-node.last()), solicited-node, "-")
      },
    ),
    bytefield(
      bpr: 1,
      section(`FFFF:FFFF:FFFF:FFFF:FFFF:FFFF:FFFF:FFFF`, `FF00::0`, span: 4),
      bits(4, fill: blue.lighten(80%))[Multicast],
      bits(1)[],
      section(`FE8F::0`, `FEB0::0`),
      bits(1, fill: green.lighten(95%))[Link/State Local],
      bits(1)[],
      section(`FDFF::0`, `FC00::0`, span: 2),
      bits(2, fill: green.lighten(95%))[Unique Local],
      bits(8)[],
      section(`3FFF::`, `2000::`, span: 4),
      bits(4, fill: green.lighten(95%))[Global Unicast],
      bits(2)[],
      section(`::FFFF:FFFF:FFFF`, `::FFFF:0:0`),
      bits(1, fill: green.lighten(95%))[Embedded],
      bits(1)[],
    ),
  ),
  caption: [Summary of the address space fragmentation],
) <address-space-summary-diagram>

=== Multicast Addresses <multicast>

Can be summarized as "`FFxx:xxx...`" or "`FF00::/8`". It's #hl[equivalent to the IPv4 multicast address `224.0.0.0/4`] (Class D, see @address-classes). Although the idea is the same, reaching a group of destination from one source, multicasting is used for completely different purposes in IPv4. It's further divided into:

/ Well-known Multicast (`FF00::/12`): reserved for communication between routers (exchanging for example router table updates etc.).

/ Transient Multicast (`FF10::/12`): equivalent to the IPv4 multicast address, they are dynamically assigned to multicast apps when needed.

/ Solicited-Node Multicast (`FF02:0:0:0:0:1:FF00::/104`): they have a similar use to ARP (mapping layer 3 address to layer 2 address).

#figure(
  bytefield(
    bpr: 32,
    bitheader("offsets"),
    bits(8)[`FF`],
    bits(4)[Flag 0RTP],
    bits(4)[Scope],
    bits(16)[Group ID],
    bits(96)[Group ID],
  ),
  caption: "Multicast Address (128 bits in rows of 32 bits)",
)

The "Flag 0RTP" also called "*T Flag*" is either:
- `0`: *permanent*, well known addresses assigned by IANA
- `1`: *transient*, assigned dynamically

The scope allows to specify "the range" of the multicast communication, in particular we have that:

- `1`: *interface-local*. Stays in the individual host.
- `2`: *link-local*. It cannot traverse the router, it's local to the subnet.
- `5`: *site-local*
- `8`: *organization-local*
- `E`: *global*

Routers immediately know which packets to forward just by looking at the address.

=== Unicast Addresses <unicast>

==== GUA | Glabl Unicast Addresses

They are equivalent to public IPv4 addresses. They are globally routable and reachable, meaning that a router receiving a packet with a GUA address knows how to reach the destination.

==== Link local / Site local Addresses

- SIte local addresses are deprecated
  - `FEC0::/10`

- Link local addresses are #underline[different from private addresses], they are used for configuration purposes
  - `FE80::/64`

==== Unique Local Addresses

They are equivalent to private IPv4 addresses.

- `FC00::/7`

The $8^"th"$ bit is a "Local (L) Flag" that is set is the address is locally assigned (zero is for future use). This means that #hl[the only valid addresses today are `FD00::/8`.]

==== IPv4 Embedded Addresses <ipv4-embedded>

They are used to represent an IPv4 address in an IPv6 address. They are used to ease the transition from IPv4 to IPv6.

The IPv4 address is carried over into the least significant 32 bits, preceded by a `::FFFF` (96 bits). For example the IPv4 address `20.10.4.3` would be mapped to `::FFFF:140A:403`.

==== Loopback Address

Equivalent to the IPv4 loopback address, canbe very compactly written as `::1`.

==== Unspecified Address

An all zeros address, is used to identify duplicate addresses.

=== Anycast Addresses <anycast>

If a packet is sent to an anycast address, the first host that receives it will reply. This is useful for example for DNS to avoid blockage if one server goes down.

== Modified Protocols

#figure(
  table(
    columns: 2,
    table.header([Changed], [Modified]),
    [IP], [DNS (type AAAA record)],
    [ICMP], [RIP and OSPF],
    [ARP (integrated in ICMP)], [BGP and IDRP],
    [IGMP (integrated in ICMP)], [TCP and UDP],
    [], [Socket interface],
  ),
)

== Comparison of IPv4 and IPv6 headers

#figure(
  grid(
    columns: 1,
    inset: 0.5em,
    bytefield(
      bitheader("offsets"),
      bits(4)[Version],
      bits(4, fill: red.lighten(80%))[IHL],
      bits(8)[Type of Service (DS)],
      bits(16)[Total Length],
      bits(16, fill: red.lighten(80%))[Identification],
      bits(3, fill: red.lighten(80%))[Flags],
      bits(13, fill: red.lighten(80%))[Fragment Offset],
      bits(8)[Time to Live],
      bits(8)[Protocol],
      bits(16, fill: red.lighten(80%))[Header Checksum],
      bits(32)[Source Address],
      bits(32)[Destination Address],
      bits(24, fill: red.lighten(80%))[Options],
      bits(8, fill: red.lighten(80%))[Padding],
    ),

    bytefield(
      bpr: 64,
      bitheader("offsets"),
      bits(4)[Ver.],
      bits(8)[Traffic \ Class],
      bits(20, fill: green.lighten(80%))[Flow Label],
      bits(16)[Payload Length],
      bits(8)[Next \ Header],
      bits(8)[Hop Limit],
      bits(128)[Source Address],
      bits(128)[Destination Address],
    ),
  ),
  caption: [Comparison of IPv4 and IPv6 Headers, in red the fields that are removed in IPv6, in green the new field],
)

As we can see the header has been simplified, for example we removed *IHL* (Header Length), this field is needed to know the length of the IP header including the options.

We also don't need any more *Identification*, *Flags* and *Fragment Offset*, these were used for fragmentation of an IP packet. The source no longer segments the packet, only routerts can fragment a packet but only if they are the source of the packet.

We also got rid of the *Header Checksum*, we alreay have checksums at Layer 3 and Layer 2 anyway so it was redundant.

*Hop Limit* is the equivalent to the *Time to live* field and measures how many hops the packet can make before being discarded (useful to avoid loops).

=== Extension headers

The *Next header* identifies the type of header that follows the current header and #hl[replaces the *Protocol* field]. We have three possibilities:

1. We have the IP header encapsulation a Layer 4 packet (for example a TCP packet), in this case the *Next header* will be `6` (TCP).
2. ICMPv6 is encapsulated
3. You have some options and then for example TCP, you have a concatenation of headers, in this case the *Next header* will be for example `0` (Hop by Hop option) and then in the next header you will have the *Next header* set to `6`.

`59` signifies no next header.

#figure(
  bytefield(
    bitheader("offsets"),
    bits(8)[Next Header],
    bits(8)[Length],
    bits(16)[Data],
    bits(32)[$dots.v$],
  ),
  caption: [Extension header format, the *Length* field is the length of the extension header],
)

==== Hop-by-Hop Extension Header

Very important for router management, always listed as first extension header.

== Interfacing with lower layers

When IPv6 packets are carried by Layer 2 packets (for example an Ethernet packet that encapsulates an IPv6 packet in a type `86DD` frame) we treat them as a new protocol. This is done to enable dual stack routers.

== Address Mapping

=== IPv6 Multicast <ipv6multicast>

We want to map our multicast addresses to Layer 2 multicast. We want to avoid the switches having to do IGMP snooping like in IPv4 (see @mac-address).

To do this mapping we simply take the last 32 bits of the IPv6 multicast address and map them to the last 32 bits of the MAC address. The first 24 bits are set to `33-33`.

#figure(
  [

    #bytefield(
      bpr: 128,
      msb: left,
      bitheader("offsets"),
      bits(96)[`FF...`],
      bits(32, fill: blue.lighten(80%))[Last 32 bits],
    )

    #grid(
      columns: 2,
      bytefield(
        bpr: 48,
        msb: left,
        bitheader("offsets"),
        bits(16)[`33-33`],
        bits(32, fill: blue.lighten(80%))[Last 32 bits],
      ),
    )
  ],
  caption: [Mapping IPv6 Multicast Address to MAC Address, the bits that are carried over are highlighted in blue],
)

== Neighbor Discovery and Address Resolution

Unicast mapping, we want to find out the Layer 2 address of our neighbors to perform direct delivery.

=== Solicited-Node Multicast Address Mapping <solicited-node-multicast-address-mapping>

ICMPv6 is based on solicited node multicast addresses (see @address-space-summary-diagram). Addresses are created by taking the 24 least significant bit of the Global Unicast Address of the host and mapping them to the last 24 bits of the Solicited Node Nulticast address.

Solicited-Node Multicast Addresses are created automatically after receiving a Global Unicast Address.

#figure(
  [
    #bytefield(
      bpr: 128,
      msb: left,
      bitheader("offsets"),
      bits(48)[`2001:DB8:CAFE`],
      bits(16)[Subnet ID],
      bits(40)[Interface ID],
      bits(24, fill: blue.lighten(80%))[Last 24 bits],
    )

    #grid(
      columns: 2,
      bytefield(
        bpr: 128,
        msb: left,
        bitheader("offsets"),
        bits(104)[`FF02::1:FF`],
        bits(24, fill: blue.lighten(80%))[Last 24 bits],
      ),
    )
  ],
  caption: [Mapping of a Global Unicast Address (top) to the Solicited-Node Multicast Address],
)

=== Address Resolution

An ICMPv6 (@icmpv6) *Neighbor Solicitation* packet is sent by a device to discover the MAC address of a neighbor connected to the network for which it knows the IPv6 address. Specifically the #hl[destination is set to be the Solicited-Node Multicast Address of the destination]. If we know the GUA we can reconstruct the Solicited-Node Multicast Address.

Given that this is a multicast packet, it will be received only by the host(s) that subscribed to the group, but only the host that created the Solicited-Node Multicast Address is subscribed to the group.

The recipient will reply with a *Neighbor Advertisement* packet in unicast because at this point it already knows the MAC address of the sender.

#info[
  You can have multiple hosts subscribed to the same Solicited-Node Multicast Address, this happens when the last 24 bits coincide. If this happens both will receive the packet but only the one matching the IPv6 address exactly will reply.
]

The mapping of IPv6 to MAC Addresses are stored in a host cache that is equivalent to the ARP cache.

== ICMPv6 <icmpv6>

Substitute for ARP in IPv4. ARP was sent to everyone in the network, in IPv6 we have a more efficient way to do this.

The next header identifier for ICMPv6 is `58`. It is encapsulated in IPv6 packets and at most 576 bytes long.

Messages are subdivided in two types - Error Messages and Informational Messages - based on the *Type* field.

=== Error Messages

The *Code* field specifies the error type.

#box(
  grid(
    columns: 2,
    inset: 0.5em,
    align: horizon,
    figure(

      bytefield(
        bitheader("offsets"),
        bits(8)[Type],
        bits(8)[Code],
        bits(16)[Checksum],
        bits(32)[Parameter],
        bits(64)[Header of the IP packets that caused the error],
      ),
    ),
    [
      / Destination unreachable (`1`): the router cannot reach the destination

      / Packet too big (`2`): the packet is too big to be delivered, it will not try to fragment it like in IPv4

      / Time exceeded (`3`): too many hops

      / Parameter problem (`4`): the packet has an error like an incorrect Next Header field, the datagram is #underline[malformed].
    ],
  ),
)

=== Informational Messages

#grid(
  columns: 2,
  inset: 0.5em,
  align: horizon,
  [
    ==== Echo

    Remember that it only tells you if the interface is reachable, not if the host is reachable.

    / Echo Request (`128`):

    / Echo Reply (`129`):
  ],
  figure(
    bytefield(
      bitheader("offsets"),
      bits(8)[Type],
      bits(8)[Code],
      bits(16)[Checksum],
      bits(16)[Identifier],
      bits(16)[Sequence Number],
      bits(64)[Data],
    ),
  ),
)

==== Neighbor Discovery

/ Neighbor Solicitation (`135`): used to discover the MAC address of a neighbor

/ Neighbor Advertisement (`136`): reply to a Neighbor Solicitation, the *Solicited* flag is set to `1` when the advertisement is a reply to a neighbor solicitation or `0` to advertise neighbors about changes on its own IP (with *Override* often set to `1`). The *Override* flag tells the sender to override the mapping in the cache.

#figure(
  bytefield(
    bitheader("offsets"),
    bits(8)[Type],
    bits(8)[Code],
    bits(16)[Checksum],
    bits(1, fill: yellow.lighten(80%))[R],
    bits(1, fill: yellow.lighten(80%))[S],
    bits(1, fill: yellow.lighten(80%))[O],
    bits(29)[Reserved],
    bits(128)[IPv6 GUA of the target],
    bits(64)[Ethernet (MAC) Address of the sender],
  ),
  caption: [Neighbor Advertisement / Solicitation Format, the flags highlighted in yellow are only utilized in the Neighbor Advertisement messsage],
)

==== Group Management

- Within a link the *Data Link Multicasting Service* is used (see @ipv6multicast)

- Beyond the link (for example multicast groups used for streaming, gaming etc.) packets are routed by routers and utilize IPv6 to find out who is subscribed to the host. Multicast routing protocols are used to route appropriately the packets.

#box(
  grid(
    columns: 2,
    inset: 0.5em,
    align: horizon,
    bytefield(
      bitheader("offsets"),
      bits(8)[Type],
      bits(8)[Code],
      bits(16)[Checksum],
      bits(16)[Maximum Response \ Delay],
      bits(16)[Unused],
      bits(128)[Multicast Address],
    ),
    [

      / Multicast Listener Query (`130`): sent by the router to the "All-Hosts" Multicast Address to discover which hosts are listening to a multicast group

      / Multicast Listener Report (`131`): sent by the listener to the "All-Routers" Multicast Address to announce that a host is listening to a multicast group

      / Multicast Listener Done (`132`): sent by the listener to the "All-Routers" Multicast Address to announce that the host is no longer listening to the multicast group
    ],
  ),
)

==== Device Configuration

In IPv4 configuration is automatically done through DHCP, in IPv6 we still have DHCP(v6) but hosts can also autoconfigure themselves through ICMPv6.

More specifically we have four ways of configuring a device:

- *Manual Configuration*: the user sets the address
- *Stateful Configuration*: done usually through DHCPv6 where we have a DHCP server that maintains the state of the network. The server knows exactly who received which address and can assign addresses dynamically. This enables the server for example to assign an address only to authorized devices and prevents address conflicts.
- *Stateless Configuration*: novel in respect to IPv4, it's automatically generated through ICMPv6 and can be done by the host with information that either the host already has or can ask the router about.
- *Hybrid (Stateless DHCP)*: there is a DHCP server, but it does not provide the address

===== Prefix

The prefix assignment, in stateless configuration, is done through the router, which sends a *Router Advertisement* packet to the network (they can be sent in response to a *Router Solicitation* packet or unsolicitally sent periodically).

#box(
  grid(
    columns: 2,
    inset: 0.5em,
    align: horizon,
    [
      / Router Solicitation (`133`): used by a host to discover routers, sent by the All-Routers Multicast address (`FF02::2`)
    ],
    bytefield(
      bitheader("offsets"),
      bits(8)[Type],
      bits(8)[Code],
      bits(16)[Checksum],
      bits(32)[Reserved],
      bits(64)[Options],
    ),
  ),
)

#box(
  grid(
    columns: 2,
    inset: 0.5em,
    align: horizon,
    [
      / Router Advertisement (`134`): used by routers to announce their presence, *Router Lifetime*, *Reachable Time* and *Retrans Timer* are usually left to zero or unspecified. The *M* flag is used to inform all listeners that there is a DHCP server on the network so the information #underline[must] be retrieved by the server. The *O* flag is set if there other addresses of additional servers in the *Optiona* (for example a DNS server). If #underline[both] flags are set to zero, the *Options* carry the prefix information.
    ],
    bytefield(
      bitheader("offsets"),
      bits(8)[Type],
      bits(8)[Code],
      bits(16)[Checksum],
      bits(10)[Cur Hop Limit],
      bits(1)[M],
      bits(1)[O],
      bits(8)[Reserved],
      bits(12)[Router Lifetime],
      bits(32)[Reachable Time],
      bits(32)[Retrans Timer],
      bits(64)[Options],
    ),
  ),
)

====== Options format

======= Prefix Information

Case router advertising the prefix, *Valid Lifetime* and *Preferred Lifetime* are usually unspecified but generally refer to the time the prefix is valid and the time the prefix is preferred. The *L* flag is set if the prefix is on-link, the *A* flag is set if the prefix can be used for autoconfiguration. If *A* is set and the *L* flag is unset, this means that the prefix is that of another link directly reachable through that router

#figure(
  bytefield(
    bits(8)[Type (3)],
    bits(8)[Length],
    bits(7)[Prefix Length],
    bits(1)[L],
    bits(1)[A],
    bits(7)[Reserved],
    bits(32)[Valid Lifetime],
    bits(32)[Preferred Lifetime],
    bits(32)[Reserved],
    bits(64)[Prefix],
  ),
  caption: [Prefix Information Option Format],
)

======= MTU

Ensures that the MTU is the same for all devices in the network.

#figure(
  bytefield(
    bitheader("offsets"),
    bits(8)[Type (5)],
    bits(8)[Length],
    bits(16)[Reserved],
    bits(32)[MTU],
  ),
  caption: [MTU Option Format],
)

======= Link Layer Address

Used to confirm the link layer address of the router (sort of a diagnostic message).

#figure(
  bytefield(
    bitheader("offsets"),
    bits(8)[Type (5)],
    bits(8)[Length],
    bits(48)[Link Layer Address],
  ),
  caption: [Link Layer Address Option Format],
)

===== Interface Identifier

To obtain an Interface ID (the trailing 64 bits of an IPv6 address) a host can either:

- Manually configure it
- Obtain it through DHCPv6
- Automatically generate it from a `EUI-64` MAC Address, which can then be used to set the last 64 bits of the IPv6 address.

To generate a `EUI-64` from a MAC address (`EUI-48`) you have to:

1. Take the MAC address
2. Insert `0xFFFE` in the middle
3. Invert the $7^"th"$ bit (the U/L bit) of the MAC address

Remember that the first 24 bits of the MAC address are the Organizationally Unique Identifier (OUI) and the last 24 bits are the device identifier, selected by the manufacturer.

For privacy reason this assigned MAC address is changed to a randomly generated one in mobile devices.

The $7^"th"$ bit (the Universal bit) is set to `0` for universally administered addresses (licensed OUI) and to `1` for addresses that have been randomly generated to changed locally. This is done to identify immediately addresses that are not the manufacturer assigned ones.

#figure(
  bytefield(
    bpr: 64,
    bitheader("offsets"),
    bits(24)[OUI + `04-00-00`],
    bits(16, fill: green.lighten(80%))[`FF-FE`],
    bits(24)[Device ID],
  ),
  caption: [EUI-64 Generation from a MAC Address],
)

Given the deterministic nature of these addresses, there are options to make it more private to what is refferred to as *Privacy Extension Algorithm*, the algorithm works by:

1. Generating a 64-bit random number
2. Appending the `EUI-64` address
3. Hashing with MD5
4. Set the $7^"th"$ bit to `0` to indicate how the address was generated

==== Redirect

/ Redirect (`137`): used by routers to inform hosts of a better route

#grid(
  columns: 2,
  inset: 0.5em,
  align: horizon,
  figure(
    bytefield(
      bitheader("offsets"),
      bits(8)[Type],
      bits(8)[Code],
      bits(16)[Checksum],
      bits(32)[Reserved],
      bits(128)[Target Address],
      bits(128)[Destination Address],
      bits(64)[Options],
    ),
    caption: [Redirect Message Header format],
  ),
  figure(
    bytefield(
      bitheader("offsets"),
      bits(8)[Type (4)],
      bits(8)[Length],
      bits(48)[Reserved],
      bits(256)[IP Header + Data],
    ),
    caption: [Redirect Options Header format],
  ),
)

== DAD | Duplicate Address Detection

When a host is assigned an address it has to check if the address is already in use. This is done through the *Duplicate Address Detection* process.

The algorithm proceeds as follows:

1. After creating an address, an IPv6 Solicited Node Multicast Address (see @solicited-node-multicast-address-mapping) is sent to the newly created address. The #hl[source MAC address is set to all zeros] (unspecified) to avoid confusion in case of an address conflict.
  - If the address is already in use, the host will receive a response.
2. Wait for a certain amount of time (usually 1 second) to receive a response. If no response is received, the address is considered unique.

= IPv4 to IPv6 Transition Mechanisms

We are currently at the point where IPv6 hosts native are widespread, but IPv4 hosts are still a good chunk of the network (as of October 2024, the IPv6 adoption rate is 46% but steadily increasing), in the future the IPv6 network will become standard and only small groups of IPv4 hosts will remain. This transition has been going on since 1996 so it's crucial to provide a way to interface the two technologies together.

There is #hl[no official switch-off date], the transition will happen gradually.

== Dual-stack approach

Based on supporting both protocols, IPv4 can be removed gradually when all hosts support IPv6.

- Host communicate natively with both
- There is a complete duplication of all the protocol stack
  - Routing tables
  - Routing protocols
  - Access lists

The problem with this approach is that it does not solve the problem of IPv4 shortage, it's costly due to the complete duplication of the stack and the choice between the two protocols is relegated to the applications. There is then the limitation of communication between IPv4-only and IPv6 hosts. While it's true that IPv6 can communicate with IPv4 hosts (see @ipv4-embedded), there is no way for an IPv4 native host to communicate with an IPv6 native host.

== Tunneling

Not used anymore due to scalability problems. It is used to exchange IPv6 packets over an IPv4 network. In the early days this was commonplace, nowadays, there are no IPv4 only ISPs.

It works by placing the #hl[IPv6 packets in the payload of the IPv4 packet]. This way the routers carry the packet without even being aware that they are carrying an IPv6 packet. This encapsulation and de-capsulation are what makes the process.

There are two protocols that can be used for tunneling:
- *GRE* | Generic Routing Encapsulation
- *IPv6 in IPv4*
  - Protocol type `41`

There are a number of solutions:

- *6to4*: was deprecated starting from 2010, 6to4 tunnels still require an IPv4 address on the routers so they actually exacerbate the problem of IPv4 shortage.
- *ISATAP*
- *Teredo*
- *6over4*

Tunneling also poses security concerns, the IPv6 packet is only read at the tunnel's entrance, this means that a potential malicious attacker tampering with it while it's being carried in the IPv4 network could go unnoticed.

== Scalable, Carrier-grade Solutions

Meaning solution that can be adopted by ISPs. They need to be robust, scalable and secure.

They are all similar in the sense that the network ISP is IPv6 native. Furthermore, they all use a NAT (recall how they work in @nat44).

=== NAT64 + DNS64

- #underline[NAT64 only works when combined with a DNS]
- The way most connections works nowadays

In this case the #hl[NAT is located on the NAT64 gateway]. We have an IPv6 host (for example your phone) that tries to contact a server (for example www.hknpolito.org), without any knowledge of the architecture of the host (if it's IPv4 or IPv6 native), by default it will query the DNS64 with `AAAA` format to obtain the IPv6 address of the server. If the server is IPv4 native, the query for a `AAAA` will return a "Name error", at this point the DNS64 will query the server again for a `A` record to obtain the native IPv4 address. The address will be returned to the host as an IPv4 embedded in an IPv6 address (@ipv4-embedded). At this point the communication can happen through the NAT64 gateway that will trannslate the TCP packet with the IPv6 address to a TCP packet with the native IPv4 address.

=== DS-Lite

- Dual-Stack only at the edge

Utilizes an *Address Family Transition Router (AFTR)* between the IPv6 ISP network and the outside IPv4 network. #hl[NAT is located on the AFTR]. The customer cannot configure the NAT.

=== A+P (DS-Lite evolution)

Like DS-Lite, it also uses an AFTR but the #hl[NAT is located on the customer's premises]. This is done to leave to the customer the choice of configuring their own port mappings.

- Ranges of TCP/UDP ports are assigned to each customer to avoid consuming too many IPv4 addresses.

= Wireless & Cellular Networks

There are two main challenges to overcome:
/ Wireless: handling communication over a wireless link with challenged like error rates, interference etc.
/ Mobility: handling mobile users that change point of attachment to the network

== Elements of a wireless network

=== Wireless hosts

- Laptops, smartphones, tablets, IoT devices
- Runs applications
- May be stationary or mobile
  - wireless $arrow.r.double.not$ mobility

=== Base Station

- Typically connected to wired network
- Relay - responsible for sending packets between wired network and wireless host in its area
  - for example cell towers, 802.11 access points etc.

=== Wireless (Broadcast) Link

- Used to connect mobile devices to base stations
- Used as a backbone link
- Multiple access protocols coordinate link access
- Various transmission rates and distances, frequency bands
- The wireless card is really what defines the link

Compared to a wired link, it suffered from a *decreased signal strength*, meaning that signal attenuates as it propagates through matter (path loss), *inference from other sources*, due to wireless network frequencies being shared by all connected devices, *multipath propagation* (echo), the phenomena of reflecting against objects that lead to the signal arriving at destination at slightly different times.

==== SNR | Signal to Noise Ratio

It's a measure used to quantify "how good" a signal is, larger SNR #sym.arrow.double easier to extract signal from noise.

When the SNR increases the BER decreases.

Higher order modulations require a higher SNR, this is due to the fact that if you want to transmit more data in a signal you need to have a cleaner signal because every error has a relatively high impact on the data.

==== Hidden Terminal Problem

It's a problem that can happen when you have three hosts A, B and C. A can communicate with B and C can communicate with B but A and C cannot communicate with each other. This can be caused by a physical obstacle that blocks the signal between A and C. A and C could choose to use the same frequencies, unaware of each other, and in doing so create interference at B.

==== Signal Attenuation

Interference caused by the signal attenuating with distance and interfering with other signals.

=== Infrastructure Mode

- Base station connects mobiles into wired network. No direct communication between two devices
- handoff: mobile changes base station providing connection into wired network

=== Ad Hoc Mode

- No base station
- Mobiles communicate peer-to-peer
- Noes can organize themselves into a network (for example mesh Wi-Fi)



