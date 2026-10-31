# Tufty handheld — full shell case (v2 — ergonomics pass)

A complete two-part shell that houses the whole Badgeware handheld stack
at once, designed against Pimoroni's own printable models:

- **Tufty 2350** (in its stock polycarbonate case) — presses into the
  badge bay and **snaps in on four internal spring clips** (two per side);
  the front bezel's window lips also retain its face.
- **Qw/ST Pad** (in Pimoroni's printable case) — drops into the lower bay,
  D-pads and buttons facing forward through their own bezel window.
- **Multi-Sensor Stick** — slides into the top bay, sensor face forward
  behind a bezel window, with vent slots at the ends for airflow.

Qw/ST cable pass-through slots are cut through both divider webs
(pad ↔ badge, stick ↔ badge) on the rear side.

## Parts

| File | What |
|---|---|
| `tufty_handheld_shell.scad` | Parametric source. Set `PART`: 0 assembled preview, 1 back shell, 2 front bezel, 3 exploded preview |
| `back_shell.stl` | Back shell — 91.0 × 127.3 × 26.7 mm (incl. grip ribs + palm swell) |
| `front_bezel.stl` | Front bezel — 89.8 × 127.3 × 2.4 mm, joins the back shell with 4× M2.5 screws into printed bosses |

Assembled size: **≈ 91 × 127 × 29 mm**, 2.4 mm walls throughout.

## v2 ergonomics pass

Same internal bays, clips, bosses and windows as v1 (fit behaviour is
unchanged); the outside got friendlier to hold:

- Corner radius 6 → **10 mm**, and the sharp 90° perimeter edges are
  gone: **3 mm chamfer** around the back face, 1.6 mm at the front,
  0.9 mm on the bezel.
- A gentle **palm swell** on the back — a shallow dome ≈ 45 × 60 mm,
  sitting 2.2 mm proud at centre height.
- **Grip ribs** on both side walls (10 bars, 7 mm pitch, lower
  two-thirds) so it resists sliding in the hand.

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

## Fit-check before printing (v2 — not yet test-printed)

1. **Badge window vs real Tufty face** — the blank buck is a solid, so
   screen and button positions could not be measured. The window leaves
   4.5 mm lips on every side of the badge face; verify no button or the
   screen edge sits under a lip.
2. **USB-C position** — a candidate cutout (12 × 5 mm) is placed in the
   bottom wall centre. Verify against the physical badge and move it
   (it is a single `box_at` line in `back_shell()`).
3. **Spring clips** — drawn as rigid 1.1 mm-proud blocks; they need a
   flex relief behind them in v2, or print in PETG and expect a firm
   press fit. Do not force the badge past them until checked.
4. **Sensor window alignment** — the stick ghost is a bounding box, not
   the real board; verify the LTR559 light/proximity face lands inside
   the 44 × 5.5 mm window and the BME280 sits under a vent slot.
5. **Qw/ST cable length/routing** — pass-throughs are placed at the rear
   of the divider webs; check cable bend radius with real cables.
6. **Screw bosses** — 2.2 mm pilot holes for M2.5 self-tappers; the top
   pair sits in the stick-bay margins, the bottom pair in the pad-bay
   margins.

## Licence note

This shell is an original design. It references Pimoroni's Badgeware
blank (OCL v1.1 + GAtt v1) and Qw/ST Pad case (BSD-2-Clause) as fit
references only — see the source model folders and `licenses/` in the
printables repo before redistributing anything bundled with them.
