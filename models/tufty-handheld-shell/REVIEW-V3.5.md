**PRINT WITH CHANGES** — the groove and documented reach corrections check out, but the two-peg fit has no guaranteed margin at the stated worst-case tolerance. Resolve that fit margin before treating v3.5 as a first-fit-ready design.

# Tufty handheld shell v3.5 verification review

Report-only review of the SCAD source and exported `back_shell.stl` and
`front_bezel.stl`. No design files were changed. Mesh checks below use
point probes of the exported triangles; they are not physical fit tests.

## 1. Pad-bay groove breakthrough — verified

The SCAD cutting box is centred at (−28, 23, 12.9), size 6 × 22 ×
2.6 mm: x −31..−25, y 12..34, z 11.6..14.2. The exported back-shell
mesh is void at z 13.91 on a grid of 32 points spanning four x positions
and eight y positions along that run. Samples just outside the x span
remain material, as expected.

At y 17..33.5, the mesh is material at z 11.5 and void at z 11.7:
the floor below the groove remains, and the groove opens above it. At
the junction (y 12.5..16), probes at z 13.91 are void into the lower
forward run. That run's SCAD box spans x −40.5..−24, y 10..16,
z 4.5..16; mesh probes across it at z 10.25 are void. The continuous
SCAD cuts and these mesh samples support a positive breakthrough with
no membrane at the former plane.

## 2. Stick pegs and seating tolerance — geometry verified; fit margin not

The source specifies Ø2.0 × 1.4 mm pegs at x −15.3/+15.5, y 128.15,
starting at z 17.97. In the exported mesh, both are present at those
centres; cross-section probes at z 18.5 bound their diameters to about
2.0 mm, and the tops are present at z 19.36 but absent by z 19.38.

For Ø3.0..3.2 mm holes, the nominal radial clearance is 0.5..0.6 mm per
peg. However, the minimum-hole case gives only 1.0 mm total clearance
across the pair. Opposing ±0.5 mm hole-position errors can change the
hole spacing by 1.0 mm, consuming all of that clearance: ideal geometry
could at best touch at the limit, with no allowance for print or
measurement variation. Thus the looser pegs improve the fit, but do not
guarantee seating under the stated worst case.

If seated, the remaining approximately ±0.6 mm location play is
acceptable for sensor visibility. The bezel window spans x −26..26;
with the board floated by ±7 mm, the sensors at board x −6.7, +2.2,
and +10.6 remain between x −13.7 and +17.6. Their stated ±0.4 mm
centreline variation also fits within the 5.5 mm window height. This
does not resolve the mechanical seating margin.

## 3. Documentation — requested docs corrected; source comments inconsistent

- The README and measurements document give the BOOT/RESET reach as
  about 14.4 mm from the panel's inside face and 16.8 mm from outside,
  and specify a tool at least 17 mm long. The only remaining ~11 mm
  references in the shell materials describe the earlier, incorrect
  standoff-datum figure; neither presents it as the current reach.
- The README correctly describes the ~7 mm at each stick end as
  PCB-end clearance and says plug-body clearance is unverified.
  However, the SCAD header still says “a plug gets ~7 mm at each end”
  and the derived-dimension comment calls it “plug room.” Those source
  comments overstate what the bay length establishes; align them with
  the README before considering this wording correction complete.
- The measurements document gives the as-built USB window as 14 × 11 mm,
  centred at shell y 76.4, z 13.5, spanning z 8..19. This matches the
  source and exported mesh probes through the wall.

## Regression spot-check

- **Bounds:** exported back shell −45.5..45.5 x, 0..141.3 y,
  0..22.47 z (91.0 × 141.3 × 22.47 mm, including grip ribs and lugs);
  bezel −44.9..44.9 x, 0..135.3 y, 0..2.4 z
  (89.8 × 135.3 × 2.4 mm).
- **Pilot holes:** source and mesh show Ø2.2 mm blind holes, 10 mm deep
  from the z 22.47 front face (bottom at z 12.47), at x ±35.5 and
  y 21.4/128.15. The lower channel ends at z 10.5, leaving 1.97 mm to
  the pilot-hole bottom; the top holes are 1.4 mm from the stick-bay
  edge (x ±33).
- **Bezel notches:** mesh openings are at the v3.3 centres:
  (−21.5, 49.8), (−2.4, 49.8), (16.3, 49.8), (36.1, 70.1),
  and (36.1, 93.4).
- **USB and rear buttons:** the USB window is 14 × 11 mm at
  (y 76.4, z 13.5). The two Ø7 mm through-holes are at
  (x 12.3/22.5, y 109.8); mesh probes are void through the panel.
- **Riser and lugs:** the source retains the riser at x −16, z 6..21.
  It also retains the two lugs at x ±26, with 16 mm width, 6 mm rise,
  and z 0..18. These match the requested regression dimensions.

The regression checks confirm the listed target geometry in v3.5. No
v3.4 mesh was available here for a direct old-to-new mesh comparison.
Physical peg seating and the other first-fit checks remain untested.
