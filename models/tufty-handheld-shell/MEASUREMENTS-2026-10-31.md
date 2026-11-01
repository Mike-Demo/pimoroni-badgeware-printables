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
  tool reaches the ~14.4 mm from the panel's inside face to the case
  back at that height — use a ≥17 mm tool; corrected in v3.5 per
  REVIEW-V3.4, the earlier ~11 mm figure used the standoff datum).

## USB-C

- On the badge's **left edge** (front view) — not the bottom edge.
  Centre y ≈ 32.5 (two photos agree within 0.5 mm). The receptacle
  housing sits ~flush/proud of the case edge, mid-thickness.
- As built: a 14 (y) × 11 (z) window through the badge bay's left
  wall, centred at shell (y 76.4, z 13.5) — spanning z 8..19, which
  covers the mid-thickness port wherever it sits in that band — so a
  plug can mate with the badge seated. (The original plan line here
  said 14 × 10 at z ≈ 9–10 without a stated datum; the SCAD window
  above is the operative one, per REVIEW-V3.4.)

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

- ~~**The Multi-Sensor Stick itself**~~ — measured 2026-11-01, see below.
- Lug snatch/drop strength (physical test on the first print).

## Multi-Sensor Stick — measured 2026-11-01

From straight-on product photos of the real stick (scale: board
length 52 mm; accuracy ±~0.5 mm). Positions along the board from its
left end, sensor side facing the viewer as photographed; the stick
can be inserted flipped, which mirrors the x positions (everything
below is near-symmetric, so orientation doesn't matter).

- **Qw/ST connectors at BOTH ends** — the stick daisy-chains.
- All sensors sit on the board's vertical centreline (±0.4 mm):
  - BME280 (TEMP/PRES/HUMID chip): 19.3 mm from left = **−6.7 from centre**
  - Gyro/accel chip: 28.2 mm = **+2.2 from centre**
  - LTR559 (LUX/PROX sensor): 36.6 mm = **+10.6 from centre**
- Mounting holes (Ø ≈ 3–3.2 mm): 10.7 and 41.5 mm from left =
  **−15.3 / +15.5 from centre**, on the centreline.
- Window check: the bezel's 52 × 5.5 mm slot covers every sensor in
  either orientation, even with the stick floated to one end of its
  bay — the window is confirmed as-is. The holes invite two small
  locator pegs on the bay's back wall to stop the stick sliding.
- Cabling note: full badge → stick → pad chaining still can't route
  through the badge bay (the badge fills it); a Qw/ST splitter in the
  badge bay's top zone is the clean way to run all three at once.
  One peripheral at a time works with the v3.3 routing.
