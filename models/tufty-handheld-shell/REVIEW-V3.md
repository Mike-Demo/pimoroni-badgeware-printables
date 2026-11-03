# Tufty handheld shell v3 — measured re-review

Review date: 2026-10-31. This is a report-only review; the SCAD and STL
design files were not changed.

## Verdict: **Print** (first-fit prototype)

The v3 geometry fixes the reviewable B1–B3, M1–M3 and M5–M6 issues. A
first back-shell/bezel fit print is reasonable. This is not a functional
release: the hardware-measurement items listed at the end remain open.
The lower pad-window lip has less than full-width front-face support on
the supplied pad-case mesh; it is a fit-check item, not a blocker to a
first test print.

## Method and mesh integrity

Rendered `PART=1` and `PART=2` from `tufty_handheld_shell.scad` with
OpenSCAD 2021.01, then measured the fresh renders, the shipped STLs, and
the imported reference STLs in Python/trimesh. The badge and pad ghosts
were transformed from their original meshes using the SCAD transforms;
the badge was lowered by 0.42 mm from its intentionally floated preview
position to evaluate its seated fit.

| Mesh | Bounds (mm) | Triangles | Watertight / bodies | Euler characteristic / genus | Volume (mm³) |
|---|---|---:|---|---:|---:|
| Back shell | 91.0 × 135.3 × 22.47 | 2,332 | yes / 1 | 2 / 0 | 115,808.85 |
| Front bezel | 89.8 × 135.3 × 2.4 | 2,104 | yes / 1 | −12 / 7 | 12,268.75 |

Fresh-render and shipped meshes agree: volume differs by 0.017 mm³ for
the back shell and 0.001 mm³ for the bezel; corresponding vertex sets
are within 0.0005 mm. PrusaSlicer 2.7.2 also reports both meshes
manifold and single-part.

The back shell remaining genus 0 is expected: the pilot holes are blind
and the divider cuts are open passages between front-facing bays, not
closed tunnels. The bezel's genus 7 corresponds to its three connected
windows plus four through screw holes; the five button notches merge
into the badge window rather than adding separate loops.

## Review items

### B1 — pilot holes and surrounding walls: **Fixed**

- Four Ø2.2 mm holes are at (±35.5, 21.4) and (±35.5, 128.15).
- Axis probes at z = 22.0, 20.0, 14.6 and 12.5 mm are void; probes at
  z = 12.4 and 1.0 mm are solid. With the front at z = 22.47, each bore
  is 10.0 mm deep and ends at z = 12.47, leaving material below.
- The tightest wall is 2.9 mm from the bottom-hole edge to the pad-bay
  edge (x = 31.5). The upper holes have 3.65 mm to the lengthened
  stick-bay edge (x = 30.75) and 6.05 mm to the top perimeter.

### B2 — bay room and divider passages: **Fixed**

- The pad bay is 38.0 mm high (y = 2.4…40.4). The stick bay is
  61.5 mm long (x = −30.75…30.75), leaving 4.75 mm at each end of a
  52 mm stick. The nearest upper pilot-hole edge is 3.65 mm outside
  that bay.
- The pad notch is x = 2…18, y = 39.4…44.4, z = 13.82…22.57 mm.
  At x = 10 and z = 14…22.4, probes across the divider are void
  continuously from the pad bay to the badge bay. The web remains
  solid behind the notch to z = 13.82; 69 mm of the 85 mm bay-width
  web remains to either side in total.
- The stick notch is x = −27…27, y = 119.4…124.4, z = 17.87…22.57 mm.
  At x = 0 and z = 18…22.4, probes are void continuously from the
  stick bay to the badge bay. It leaves 15.5 mm of web at each side
  and solid web behind it to z = 17.87.
- The pad case top is at y = 31.9 and the divider begins at y = 40.4:
  8.5 mm of +y room. At x ≈ +10 the notch opens through the divider,
  so the connector route is not capped by the web.

### B3 — dead-end USB pocket: **Fixed**

There is no USB-C pocket or replacement opening in the back-shell
geometry. The source and README identify the real port opening as
pending a hardware measurement; no misleading cutout remains.

### M1 — badge retention: **Fixed**

No spring clips remain in the SCAD or mesh. Probes at the former clip
locations (x = 41.9, y = 58.5/89.3, z = 17.7…22.4) are void. Retention
is by the four rear standoffs and bezel lips, with about 0.5 mm lateral
clearance to the seated badge.

### M2 — button notches and badge face stop: **Fixed geometrically**

- The bezel has five 8.8 × 8.8 mm through-notch cutters at badge-relative
  centers (−18, 6), (0, 6), (18, 6), (36, 24), and (36, 42) mm.
  In shell coordinates these are (−18, 49.9), (0, 49.9), (18, 49.9),
  (36, 67.9), and (36, 85.9).
- The reference badge mesh gives cap tops at z = 23.77 mm at all five
  centers. The bezel front is z = 24.87, leaving 1.10 mm above the
  caps. The 8.8 mm notches leave 1.0 mm per side around the modeled
  6.8 mm caps.
- The seated badge face is at z = 22.27; the bezel underside is
  z = 22.47, a 0.20 mm face-to-bezel gap. `badge_cav_d` is 20.07 mm,
  as required.

These are measured against the modeled badge caps. Physical button
center confirmation remains an explicitly open measurement item.

### M3 — standoffs and residual depth gaps: **Fixed**

- Four Ø4 mm standoffs are at x = ±37.5 and y = 55/98, with tops at
  z = 13.57. Seated-badge surface probes at those positions hit
  z = 13.567…13.569 mm: contact within 0.003 mm, with no meaningful
  post/badge interference. The badge footprint has 0.5 mm clearance
  to the cavity on each x and y side.
- `pad_cav_d` = 8.55 mm for the 8.35 mm pad case. The placed reference
  case spans z = 14.02…22.37 in its 13.92…22.67 cavity, leaving
  0.10 mm at the front and back.
- `stick_cav_d` = 4.5 mm for the 4.2 mm stick. The centered stick spans
  z = 18.12…22.32 in its 17.97…22.67 cavity, leaving 0.15 mm at the
  front and back.
- The badge has the intended 0.20 mm front gap from M2. At the badge
  back panel, a few STL vertices are 0.003 mm below z = 2.4 due to
  mesh precision; this is a contact/tessellation-scale discrepancy,
  not a design-scale collision.

### M5 — swell and back-down print: **Fixed**

`swell_depth` is zero (the source value is `swell_depth = 0`); the
back-shell mesh has no geometry below its planar z = 0 back face. A
support-free PrusaSlicer 2.7.2 back-down slice completed at 0.2 mm
layers, 3 perimeters, 5/4 top/bottom layers, 15% gyroid, and the review
speeds (45/25/80 mm/s): **5 h 04 min, 69.71 g PLA**. With automatic
supports enabled, the slicer added only 0.92 g of localized support,
not support under the former broad palm-swell area.

The matching flat-bezel slice was **1 h 00 min, 13.69 g PLA**. Thus
the README's shell estimate (about 5 h/69 g) is consistent; its bezel
mass estimate (about 12 g) is low by roughly 1.7 g under this profile.

### M6 — bay-corner root and front rim: **Fixed**

At the side section through the badge bay, the shortest root from the
inner corner (x = 42.5, z = 2.4) to the 1.5 mm back-bevel surface is
2.33 mm, up from 1.28 mm in the v2 review. At the front rim, the
0.8 mm front bevel leaves 1.60 mm from the badge-bay wall (x = 42.5)
to the outer side (x = 44.1), up from 0.91 mm.

### Minors

| Item | Verdict | Mesh/source evidence |
|---|---|---|
| m1 counterbores | **Fixed** | Four Ø5.0 mm counterbores start 1.2 mm below the bezel face and cut 1.2 mm deep (with 0.1 mm boolean overshoot). |
| m2 pilot sizing | **Fixed** | The source specifies Ø2.2 mm for PLA and notes Ø2.35 mm for PETG. |
| m3 stick window | **Fixed** | One 52 × 5.5 mm bezel slot; there are no separate vent slots. |
| m4 grip ribs | **Fixed** | Nine ribs per side, centered at y = 14…70 mm in 7 mm steps; their y extent is 12.3…71.7 mm. |
| m5 dimensions | **Fixed** | README dimensions match the meshes: back shell 91.0 × 135.3 × 22.47 mm; bezel 89.8 × 135.3 × 2.4 mm. Assembled depth is 24.87 mm (about 25 mm). |

## Regressions and new findings

### Low — lower pad-window lip has a reduced contact land

The pad window is centered at y = 17.4 mm, the center of the placed
29 mm-high pad case, not at the taller bay center. Its 55 × 22 mm
opening leaves nominal 3.5 mm overlaps at the top and bottom of the
62 × 29 mm case. Probes on the upper lip show front-face support across
the full window width. On the lower lip, the case mesh has a flat
front-face land across approximately x = −24.4…24.4 mm near y = 5.5…6
mm, but its lower corners and lowest portion recede. The lower lip
therefore overlaps the case but is not supported across its entire
width/height. There is no modeled collision; verify this land on the
physical case during the first-fit print.

### Informational — source comment typo

The SCAD header comment says `stick_cav_d = stick_t + 3` while calling
that a 0.3 mm clearance. The executable definition is correctly
`stick_t + 0.3`; this is comment-only and does not change the mesh.

### No top-boss or web failure found

The shell is 8 mm taller than v2 (135.3 mm). Screw rows are now at
y = 21.4 and 128.15 mm, 106.75 mm apart (4 mm farther apart than the
v2 rows); the upper hole retains 6.05 mm to the top edge and 3.65 mm
to the stick cavity. The nine-per-side grip ribs remain in the lower
y = 12.3…71.7 mm band and do not extend into the stick bay. The notch
cuts preserve substantial side webs and the rear material noted under
B2. None of these changes creates a new geometry blocker.

## Explicitly open hardware measurements

The following are unchanged and are not v3 failures: USB-C opening
position, badge Qw/ST socket reach, BOOT/RESET rear-hole positions,
physical button-center confirmation, and stick connector/sensor
positions. They prevent final functional validation, but do not
prevent a first fit-only test print. No other item blocks that print.
