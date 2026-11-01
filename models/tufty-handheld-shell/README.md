# Tufty handheld — full shell case (v3.6 — pin-and-slot stick locators)

A complete two-part shell that houses the whole Badgeware handheld stack
at once, designed against Pimoroni's own printable models:

- **Tufty 2350** (in its stock polycarbonate case) — rests on four rear
  standoffs in the badge bay; the front bezel's window lips retain it.
- **Qw/ST Pad** (in Pimoroni's printable case) — lower bay, D-pads and
  buttons facing forward through their own bezel window, with 8 mm of
  plug room above it.
- **Multi-Sensor Stick** — top bay, sensor face forward behind a
  full-length bezel window.

Qw/ST cabling (v3.3): the badge → stick cable passes over the badge's
top through a riser in the upper divider, at the badge socket's x.
The pad run is internal too: plug the badge end first, drape the
cable down the badge bay's back-left gutter and through the channel
behind the pad bay, seat the badge, then plug the pad end (it emerges
in the plug room above the pad). A USB-C window in the left wall and
BOOT/RESET holes in the back panel (both v3.3, measured) mean the
badge rarely needs to come out.

**Wearing it:** two lugs on the top edge of the back shell (v3.1, see
below) take a lanyard cord or split-ring clips, so the unit can still
be worn as a badge. The Tufty's own lanyard tab stays enclosed — the
stick bay sits directly above it.

## Parts

| File | What |
|---|---|
| `tufty_handheld_shell.scad` | Parametric source. Set `PART`: 0 assembled preview, 1 back shell, 2 front bezel, 3 exploded preview |
| `back_shell.stl` | Back shell — 91.0 × 141.3 × 22.47 mm (width incl. grip ribs, height incl. lanyard lugs) |
| `front_bezel.stl` | Front bezel — 89.8 × 135.3 × 2.4 mm, joins with 4× M2.5 × 8 screws into 10 mm blind pilot holes (Ø2.2 PLA; open to Ø2.35 for PETG) |

Assembled size: **≈ 91 × 141 × 25 mm** (135 mm tall without the lugs),
2.4 mm walls throughout.
Print guidance (from the review's slicing): back shell **back-face
down, no support** (≈ 5 h, ≈ 69 g PLA without the swell); bezel flat,
either face down (≈ 1 h, ≈ 14 g PLA). Do not print the shell front-down
(the badge-bay ceiling would need ~30 cm³ of internal support).

## v3 — what changed (Copilot review, PR #2)

The v2 design was reviewed report-only by Copilot (full text:
[`REVIEW.md`](https://github.com/Mike-Demo/pimoroni-badgeware-printables/blob/copilot/design-review-tufty-handheld-shell/models/tufty-handheld-shell/REVIEW.md)
on the review branch). Verdict was **do not print yet**. v3 applies
every fix that does not need measurements from a physical badge:

- **B1** — the old screw "bosses" were no-ops whose pilot holes were
  refilled by the shell union. Boss loop deleted; real Ø2.2 blind pilot
  holes are now subtracted in the main difference.
- **B2** — the old cable "pass-throughs" were blind pockets. Deleted;
  pad bay is 8 mm taller (plug room), stick bay lengthened to 61.5 mm,
  and both divider webs are notched from the front so cables connect.
- **B3** — the dead-end USB-C pocket is deleted (see pending list).
- **M1** — spring clips deleted (option A): they were a permanent
  0.6 mm wedge, not a snap. Badge location is now standoffs + bezel.
- **M2** — 8.8 mm bezel notches over the five button caps (positions
  from the buck's modelled caps), and `badge_cav_d = badge_d − 1.3` so
  the case face, not the buttons, is the forward stop (0.2 mm gap).
- **M3** — four Ø4 rear standoffs (tops at the review-measured
  z 13.57); `pad_cav_d = pad_d + 0.2`; `stick_cav_d = stick_t + 0.3`
  — the rattle gaps are closed.
- **M5** — palm swell removed (`swell_depth = 0`): it forced support
  under the whole hand surface and rocked on a table.
- **M6** — chamfers reduced (back 3.0 → 1.5, front 1.6 → 0.8): the
  bay-corner root is back to ≈ 2.33 mm and the front rim to ≈ 1.6 mm.
- **Minors** — bezel holes counterbored Ø5.0 × 1.2 (m1); stick window
  is one full-length 52 × 5.5 slot (m3); README numbers corrected —
  9 grip ribs per side (m4), dimensions above are re-measured (m5).

Verified after export with mesh point-probes: pilot holes are void
for their full 10 mm and blind below; both divider notches are
continuous pad→badge and stick→badge; standoffs present at all four
sites; no clip or swell geometry remains.

## v3.1 / v3.2 — lanyard lugs

Two rounded lugs rise 6 mm above the back shell's top edge at
x ±26 mm (kept inside the corner radii and clear of the top pilot
holes). Each is 16 mm wide × 18 mm deep with a 10 × 2.6 mm
through-slot (front to back) for a lanyard cord or split-ring
clips — two-point attachment, so the unit hangs flat like a
conference badge. The re-review's **Print** verdict (REVIEW-V3.md)
predates the lugs; they change nothing it measured inside the shell.

The lug delta got its own review (REVIEW-V3.1.md, verdict *keep with
changes*), and v3.2 applies its two findings: the lugs now run the
full depth band from **z 0**, printing as columns from the bed — in
v3.1 they started at z 4, which left the rise as an unsupported
ledge and broke the support-free claim (P2); and the slot ends are
fully rounded (stadium profile) instead of square-cornered, for the
stress-concentration point (P3). Probe-verified: slots through
across the whole band, lug material continuous to the bed, rounded
corners filled, stick bay and pilot holes unaffected. Snatch/drop
strength remains a physical-test item, as the review noted.

## v3.3 — measured hardware fixes

Everything below was measured on a real Tufty 2350 from photographs
with rulers (positions cross-checked across two photos, ±~1.5 mm;
full record in the design notes, `MEASUREMENTS-2026-10-31.md`).
Badge-relative coordinates are from the case's bottom-left corner,
front view.

- **Bezel notches moved to the real caps** — A (−21.5, 5.9),
  B (−2.4, 5.9), C (+16.3, 5.9), Down (+36.1, 26.2), Up (+36.1, 49.5).
  The buck-derived positions were up to 7.5 mm off: the old Up notch
  would have trapped most of the Up cap under the bezel lip.
- **USB-C (B3, closed)** — the port is on the badge's **left edge**,
  centre 32.5 mm up from the case bottom, ~flush with the case edge.
  The shell's left wall now has a 14 × 11 mm window there, so a plug
  can mate with the badge seated (slim plugs fit best). The left grip
  rib at that height is omitted (8 ribs on the left, 9 on the right).
- **BOOT / RESET (M4, closed)** — Ø7 mm holes through the back panel
  at RESET (+12.3, 65.9) and HOME (+22.5, 65.9); the plungers are
  ~Ø4.5 mm. Reach corrected in v3.5: the case back at the buttons
  sits ~14.4 mm from the panel's inside face (~16.8 mm from outside),
  so use a tool at least ~17 mm long. The rear lighting stays covered.
- **Qw/ST routing (B2 tail, closed for the badge end)** — the badge's
  socket is at the top edge of its case (x −16, facing up). A riser
  opening in the upper divider (z 6–21, merging with the front notch)
  takes the badge → stick cable. The pad channel runs from the badge
  bay's back-left gutter down behind the pad bay and up a groove in
  its floor into the plug room; the channel keeps 1.97 mm from the
  bottom-left pilot hole (probe-verified).

Verified after export with 38 mesh point-probes: window, holes,
riser, and full channel path void where they should be; pilot holes,
standoffs, lugs, and cavities unchanged.

## v3.4 — the stick, measured

The Multi-Sensor Stick was the last unmeasured part. From product
photos of the real board (52 mm long; positions ±~0.5 mm):

- **Qw/ST connectors at both ends** — it daisy-chains. The stick bay
  is lengthened 61.5 → 66 mm, giving ~7 mm from each PCB end to the
  bay end with the stick centred (plug-body clearance itself is
  unverified; the top pilot holes keep 1.4 mm of wall).
- **Mounting holes** Ø ≈ 3–3.2 mm at −15.3 / +15.5 mm from centre get
  two **locators** on the bay's back wall (Ø2.5 pegs in v3.4, Ø2.0 in
  v3.5, **pin-and-slot from v3.6** — see below): the stick registers
  in place, can't slide or rattle between its plugs, and stays put
  in its clip orientation.
- **Sensors verified against the window** — BME280 −6.7 mm, gyro
  +2.2, LTR559 +10.6, all on the board's centreline: the full-length
  52 × 5.5 mm window covers all three in either orientation, so the
  window is unchanged.

One cabling truth worth recording: a badge → stick → pad chain
still can't be routed through the badge bay (the badge fills it).
All three at once wants a small Qw/ST splitter in the badge bay's
top zone — one leg up the riser to the stick, one down the gutter
channel to the pad. One peripheral at a time works today.

Verified after export with 43 mesh point-probes (the v3.3 set plus
pegs present, bay end extended, pilot wall intact).

## v3.5 — the final review's fixes

The final review (`REVIEW-V3.4.md`, verdict *PRINT WITH CHANGES —
first-fit prototype*) independently confirmed every measured
placement, and found three things to fix:

1. **The pad groove stopped 0.02 mm short** — it ended at z 13.90
   against the pad bay's floor face at z 13.92, leaving a skin the
   cable exit depended on the slicer discarding. The groove now runs
   to z 14.2 and breaks through positively (a probe at the old
   membrane plane, z 13.91, now reads void).
2. **Pegs loosened** — Ø2.5 pegs in Ø3.0–3.2 holes left only
   0.25–0.35 mm radial clearance against the ±0.5 mm photo tolerance;
   opposing errors could have kept both pegs from seating at once.
   The pegs are now **Ø2.0** (0.5–0.6 mm radial clearance) — they
   still locate the stick to ~±0.6 mm instead of a 7 mm float.
3. **BOOT/RESET reach corrected** — the case back at the buttons
   sits higher than the standoff datum the v3.3 text used: ~14.4 mm
   from the panel's inside face, ~16.8 mm from outside. Use a
   ≥17 mm tool. (Text fix only; the holes were already right.)

Also noted by the review, unchanged: the cable route's narrow
section (6 × 2.3 mm) passes a connector-free lead up to ~4.5 × 1.5 mm
with plug housings outside the channel — the real lead's dimensions
remain a first-fit check, and SLS nylon powder removal from that
route may be fiddly. Verified after export with 44 mesh point-probes
(the v3.4 set plus the membrane point).

## v3.6 — pin-and-slot

The verification review (`REVIEW-V3.5.md`, verdict *PRINT WITH
CHANGES*) confirmed the groove breakthrough (32-point grid, no
membrane) and the doc corrections, with one margin left open: with
minimum-size holes, the Ø2.0 peg pair's total clearance (1.0 mm) is
exactly consumed by worst-case opposing spacing errors (±0.5 mm
each) — seating possible, but with zero margin.

v3.6 resolves it the standard way: **pin-and-slot**. The −15.3
locator stays a round Ø2.0 × 1.4 pin (sets x and y); the +15.5
locator is now a capsule rib, Ø2.0 wide × 5.5 long in x × 1.4 high —
it sets y only, and any hole-spacing error simply slides along the
slot. The review's other note is also closed: the SCAD header and
dimension comments now say "PCB-end room" like the README, not
"plug room". Verified after export with 47 mesh point-probes (pin
and rib present, air beside and beyond the rib, all v3.5 checks
unchanged).

## Still pending — physical checks only

1. **First-fit checks** — bezel pad-window lip contact on the real
   pad case; USB-C plug clearance through the wall window; BOOT/RESET
   tool reach; peg fit in the stick's holes; lug snatch/drop strength.
2. All measurement items are closed (badge 2026-10-31, stick
   2026-11-01; record in `MEASUREMENTS-2026-10-31.md`).

## Reference dimensions (measured from Pimoroni's STLs, 2026-10-31)

- Badgeware badge-in-case solid: 84.0 × 76.0 × 21.37 mm
- Qw/ST Pad case, assembled: 62.0 × 29.0 × ~8.35 mm
- Multi-Sensor Stick: 52.0 × 7.9 × 4.2 mm (user-supplied)

The SCAD imports those STLs **only as preview ghosts** (`PART=0/3`,
background `%` geometry). The exported part STLs contain none of
Pimoroni's geometry. The imports are sibling-relative
(`../pimoroni-badgeware-blank/…`, `../qwst-pad-game-controller-case/…`),
so the preview resolves when this folder sits at
`models/tufty-handheld-shell/` in the printables repo, as it does here.

## Licence note

This shell is an original design. It references Pimoroni's Badgeware
blank (OCL v1.1 + GAtt v1) and Qw/ST Pad case (BSD-2-Clause) as fit
references only — see the source model folders and `licenses/` in the
printables repo before redistributing anything bundled with them.
