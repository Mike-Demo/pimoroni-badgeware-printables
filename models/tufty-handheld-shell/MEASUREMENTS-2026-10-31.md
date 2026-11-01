# Tufty 2350 hardware measurements — from Demo's photos, 2026-10-31

Measured from 17 photos of Demo's real badge (rulers + case outline as
references; positions cross-checked across two independent photos where
possible; estimated accuracy ±1.5 mm). Frame: **badge-relative, front
view** — origin at the bottom-left corner of the badge's case, +x right,
+y up. Case is 84 mm wide; case bottom = badge y 0; case top ≈ y 69;
header strip (lanyard tab) tops out at y 76.

## Front buttons (cap centres) — vs the v3.2 bezel-notch assumptions

| Button | Measured | v3.2 assumption | Shift |
|---|---|---|---|
| A | (−21.5, 5.9) | (−18, 6.0) | −3.5 x |
| B | (−2.4, 5.9) | (0, 6.0) | −2.4 x |
| C | (+16.3, 5.9) | (+18, 6.0) | −1.7 x |
| Down | (+36.1, 26.2) | (+36, 24) | +2.2 y |
| Up | (+36.1, 49.5) | (+36, 42) | **+7.5 y** |

Bottom row y (5.9) and right-column x (+36.1) confirmed. The Up notch in
v3.2 (spans y 37.6–46.4) would have left most of the Up cap (45.8–53.2)
under the bezel lip — the notches must move to the measured centres.

## Rear buttons (BOOT/HOME and RESET)

- HOME (+22.5, 65.9), RESET (+12.3, 65.9) — front-view x (they appear
  left-of-centre from the back), 10.2 mm apart, ~3 mm below the case
  top edge, plunger Ø ≈ 4.5 mm.
- Plan: Ø7 mm access holes in the shell's back panel at these
  positions (extra Ø covers photo + print tolerance; a paperclip/SIM
  tool reaches the ~11 mm from panel to case back).

## USB-C

- On the badge's **left edge** (front view) — not the bottom edge.
  Centre y ≈ 32.5 (two photos agree within 0.5 mm). The receptacle
  housing sits ~flush/proud of the case edge, mid-thickness.
- Plan: 14 (y) × 10 (z) window through the badge bay's left wall,
  centred z ≈ 9–10, so a plug can mate with the badge seated.

## Qw/ST socket (badge side)

- At the **top edge of the case**, x ≈ −16, facing up toward the
  header strip (under the header's SWD/I2C labels). A plugged JST-SH
  needs ~15 mm above the badge top → collides with the stick-bay
  floor band unless a pocket is cut there.
- Plan for v3.3: plug pocket in the divider band above the badge at
  x −16, plus a shallow cable channel down the back of the badge bay
  so the chain can run badge → stick (top bay) → pad (bottom bay).
  Stick-side connector positions still unmeasured (see below).

## Other observations

- Rear-light windows: small rectangular windows on both case side
  edges at y ≈ 10.4 and ≈ 53.7 (the four lighting zones). The shell's
  side walls will cover them; noted, no action unless wanted.
- Header strip is exposed PCB above the case (TUFTY / SWD / I2C /
  DISK·SLEEP labels, lanyard slot) — inside the shell it sits in the
  badge bay's top region, as modelled.

## Still unmeasured

- **The Multi-Sensor Stick itself**: which end the Qw/ST connector(s)
  are on, and where the LTR559 / BME280 sit vs the stick window.
  No stick photos were in this batch.
- Lug snatch/drop strength (physical test on the first print).
