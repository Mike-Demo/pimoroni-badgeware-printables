# Tufty handheld — full shell case (v3 — Copilot review fixes applied)

A complete two-part shell that houses the whole Badgeware handheld stack
at once, designed against Pimoroni's own printable models:

- **Tufty 2350** (in its stock polycarbonate case) — rests on four rear
  standoffs in the badge bay; the front bezel's window lips retain it.
- **Qw/ST Pad** (in Pimoroni's printable case) — lower bay, D-pads and
  buttons facing forward through their own bezel window, with 8 mm of
  plug room above it.
- **Multi-Sensor Stick** — top bay, sensor face forward behind a
  full-length bezel window.

Qw/ST cables pass through notches cut in the front of both divider webs
(pad ↔ badge, stick ↔ badge).

## Parts

| File | What |
|---|---|
| `tufty_handheld_shell.scad` | Parametric source. Set `PART`: 0 assembled preview, 1 back shell, 2 front bezel, 3 exploded preview |
| `back_shell.stl` | Back shell — 91.0 × 135.3 × 22.47 mm (width incl. grip ribs) |
| `front_bezel.stl` | Front bezel — 89.8 × 135.3 × 2.4 mm, joins with 4× M2.5 × 8 screws into 10 mm blind pilot holes (Ø2.2 PLA; open to Ø2.35 for PETG) |

Assembled size: **≈ 91 × 135 × 25 mm**, 2.4 mm walls throughout.
Print guidance (from the review's slicing): back shell **back-face
down, no support** (≈ 5 h, ≈ 69 g PLA without the swell); bezel flat,
either face down (≈ 1 h, ≈ 12 g PLA). Do not print the shell front-down
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

## Still pending — needs measurements from a real Tufty / stick

1. **USB-C opening (B3)** — measure the port's position on the badge
   edge; cut a 12 × 7 mm through-opening in the wall opposite it.
2. **Badge Qw/ST socket position (B2 tail)** — confirm the badge-end
   cable reach/bend through the new divider notches.
3. **BOOT / RESET access (M4)** — both buttons (and the rear lighting)
   sit behind the solid back panel. Measure positions; add Ø6 mm
   access holes.
4. **Button centres (M2)** — the bezel notches are placed from the
   buck's modelled caps; confirm against the real badge before relying
   on them.
5. **Stick details** — connector end (the stick notch is cut wide to
   cover either end) and LTR559 / BME280 positions vs the window.

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
