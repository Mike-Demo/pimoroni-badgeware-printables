# Tufty handheld full shell — v3.4 final review

**Verdict: PRINT WITH CHANGES — first-fit prototype only.**

The measured feature centers and exported shell geometry mostly agree. The
current files are not ready to be treated as a final fit, however: the pad
cable groove meets the pad bay through a modeled 0.02 mm membrane, the peg
fit is tighter than the stated measurement uncertainty, and the rear-button
tool reach is longer than the README claims. Make the cable opening positive
and either loosen or omit the pegs for the first fit. Use a sufficiently long
tool and verify the rear buttons physically.

## Scope and method

This review covers only the v3.3/v3.4 measured-hardware delta. I derived the
coordinates from `tufty_handheld_shell.scad` and the stated seated-badge
frame, then probed triangle intersections in the checked-in binary STLs at
the feature locations. The exported meshes have the documented overall
bounds. OpenSCAD and a slicer were not available, so this is not a new
slice, watertightness certification, or physical fit test.

## Placement and mesh checks

The derived layout is `y_badge = 43.4`, seated badge bottom `43.9`,
`y_stick = 123.4`, and stick-bay center `128.15` mm.

| Feature | Derived shell placement | Check |
|---|---|---|
| Bezel button notches | A/B/C y = 49.8; Down y = 70.1; Up y = 93.4 mm. x centers are −21.5, −2.4, +16.3, +36.1, +36.1 mm. | Matches `button_notches` and bezel subtraction. The Up opening moved +7.5 mm from the former y=42 badge-relative position. The photo-derived ±1.5 mm uncertainty means the centers implement the estimate, not guaranteed physical clearance. |
| USB-C | Center (x, y, z) = (−43.7, 76.4, 13.5) mm; opening y=69.4–83.4, z=8–19 mm. The cut extends through the 2.4 mm left wall; badge-edge-to-wall gap is 0.5 mm. | A ray through the exported shell at the window center finds no left-wall material. The opening is clear of the back/front bevel bands and the y=70 left rib is omitted. Outside the aperture the side wall remains 2.4 mm thick; no wall remains through the aperture. A slim plug should have access; verify the plug body and cable exit on hardware. |
| BOOT/RESET | RESET (12.3, 109.8), HOME (22.5, 109.8) mm; Ø7 mm through the 2.4 mm back panel. Hole centers are 10.2 mm apart, leaving a 3.2 mm web. | Exported-mesh rays through both centers pass through the panel. The holes are well clear of the four standoff locations and of one another. Each Ø4.5 mm plunger has 1.25 mm nominal radial clearance in its hole. |
| Qw/ST riser | x=−16; cut x=−22…−10, y=119.5…124.3, z=6…21 mm, merged with the 54 mm-wide front divider notch. | The mesh has only the z=0…6 mm rear web at the sampled riser center; the opening continues into the existing front notch. It removes a narrow strip at the bottom of the stick-bay floor, but does not reach the stick centerline or locator pegs. |
| Pad cable route | Drop x=−40.5…−34.5, y=10…44.4, z=4.5…10.5; turn x=−40.5…−24, y=10…16, z=4.5…16; floor groove x=−31…−25, y=12…34, z=11.6…13.9 mm. | Mesh samples confirm the drop, turn, and groove cuts. The lower pilot hole begins at z=12.47, leaving the claimed 1.97 mm vertical separation from the drop. The drop leaves 4.5 mm of material behind it at its deepest point; the outer-side margin is 4.4 mm. |
| Stick bay and pegs | Bay x=−33…+33 mm; stick is 52 mm long. Peg centers x=−15.3/+15.5, y=128.15, z=17.97…19.37 mm; stick-bay floor is z=17.97. | The STLs show the bay and the two 2.5 mm × 1.4 mm pegs. With the centered 4.2 mm-thick stick, peg penetration is about 1.25 mm. The top pilot-hole inner edges are x=±34.4, leaving 1.4 mm between each bay end and its pilot hole. |

The exported `back_shell.stl` bounds are 91.0 × 141.3 × 22.47 mm (including
grip ribs and lugs); `front_bezel.stl` is 89.8 × 135.3 × 2.4 mm. These match
the README. Mesh probes also confirm the through-holes, USB-side opening,
riser, and bay-end/pilot-hole separation at the sampled sections.

## Findings before relying on the fit

1. **Cable-groove connection leaves only a 0.02 mm skin.** The pad-bay cavity
   begins at z=13.92 mm, while the floor groove ends at z=13.90 mm. The STL
   therefore retains a 0.02 mm skin between the groove and the pad room.
   That is below normal FDM layer/nozzle resolution, so a slicer may discard
   it, but the routed cable currently depends on that behavior. Extend the
   groove positively into the bay (for example, to z=14.2 mm) and confirm
   the connection in a slice before calling the path resolved.

2. **Peg fit is not assured by the photo measurements.** A Ø2.5 mm peg in a
   Ø3.0–3.2 mm hole has only 0.25–0.35 mm radial clearance, versus the
   stated ±0.5 mm positional accuracy. Opposing errors across the two-hole
   pattern can prevent both pegs seating at once. The pegs do locate the
   board if they fit; for the first-fit print, omit or make them optional
   until hole centers are measured directly on the board.

3. **Rear-button reach is understated.** The README's approximately 11 mm
   uses the standoff/panel datum, not the local button position. Applying
   the SCAD badge-ghost transform to the reference badge STL puts the rear
   surface at the two button centers near z=16.79 mm. That is about 14.39 mm
   from the panel's inner face (z=2.4), or 16.79 mm from its outside face.
   The Ø7 holes provide ample lateral clearance, but use a tool long enough
   to reach that distance and verify the actual plunger depth and actuation.

4. **Cable size and bend are assumptions, not measured fit.** The route's
   narrow section is 6 × 2.3 mm. It should pass a flexible, connector-free
   four-conductor cable no larger than about 4.5 mm wide × 1.5 mm thick;
   the plug housings must remain outside the channel, as the README's
   plug-badge-first/plug-pad-last sequence requires. Tight corners and
   insulation bend radius could still make a particular Qw/ST lead
   difficult to route. The real lead dimensions were not supplied.

## Structure and printability

- The USB aperture removes the full side-wall thickness locally. Its
  14 × 11 mm opening is away from the back and front bevels, but does create
  a 14 mm interruption in the left side rail; the omitted grip rib is
  correctly the one that would cross it.
- The cable drop does not intersect the lower-left pilot hole: their x
  ranges overlap, but the closest z faces remain 1.97 mm apart. The route
  does not cut through the outer side wall. The groove preserves 11.6 mm
  of back material behind its deepest cut; its issue is the 0.02 mm
  connection to the pad cavity, not loss of the back wall.
- The two rear holes leave a 3.2 mm web and do not approach the standoffs.
  The longer stick bay clears the top pilots, but its 1.4 mm remaining web
  is narrow; inspect the screw region after the first print.
- With the specified back-face-down orientation, the enclosed channel's
  drop is 6 mm wide. The lower turn is a 16.5 × 6 mm cut, but much of it
  opens into the pad bay; its closed span is at most about 9 mm. The floor
  groove is 6 mm wide. These are reasonable PLA bridges with good cooling;
  PETG may sag more at the turn. The riser opens into the existing divider
  notch rather than forming a long enclosed tunnel. The USB window bridges
  only the 2.4 mm wall thickness.
- The pegs are short vertical cylinders, so they need no support; Ø2.5 ×
  1.4 mm should print cleanly with ordinary FDM settings. SLS nylon avoids
  bridge sag, but powder removal from the 6 × 2.3 mm route is a concern.
- A new slicer check is still needed. The README's no-support estimate
  predates the v3.3/v3.4 cuts and does not establish how the 0.02 mm groove
  membrane or the turn will slice.

## Stick window and documentation

The 52 × 5.5 mm bezel slot is centered at x=0 and y=128.15. Sensor centers
at x=−6.7, +2.2, and +10.6 mm are well inside its ±26 mm length and lie on
the stick centerline. Even with the stick unlocated at either end of the
66 mm bay, a 7 mm shift puts the furthest listed sensor at x=17.6 mm, still
inside the slot. With pegs engaged, the stick is nominally centered and
cannot float by 7 mm; the window remains adequate in either end-for-end
orientation.

The current README and SCAD agree on the measured notch centers, USB
14 × 11 mm cut, rear-hole centers, riser, cable route, 66 mm stick bay, peg
sizes, and sensor/window positions. There are two claims to qualify before
calling the design final: the README's ~11 mm rear-button reach is short by
the mesh-derived distance above, and its “~7 mm” at each stick end is the
clearance from the PCB end, not verified connector/plug clearance. The
measurement note describes the USB opening as 14 × 10 mm with a z≈9–10
center without identifying that z datum; the SCAD's operative shell
opening is 14 × 11 mm centered at z=13.5. The earlier v3 section's 61.5 mm
bay and buck-derived button positions are explicitly historical, not the
current v3.4 geometry. The all-three-peripheral cable-chain limitation is
also documented correctly: a splitter is needed to connect all three at
once.

## First-fit checklist

- Confirm the pad cable route is open in the sliced STL and pass the actual
  Qw/ST lead through before installing the pad.
- Check the real stick holes against the pegs; do not force the board if
  either peg binds.
- Verify USB plug insertion, rear-button tool reach/actuation, and pad fit
  on the assembled hardware.
- Inspect the 1.4 mm top-pilot web and the lower cable-channel turn after
  printing.
- Treat the lanyard-lug snatch/drop strength as the separately tracked
  physical test; it is outside this review.
