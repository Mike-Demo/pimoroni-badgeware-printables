# Tufty handheld shell v3.1 — lanyard lug review

## Scope and method

This is a report-only review of the two lanyard lugs added in v3.1. The
previously reviewed v3 geometry is out of scope except where the lugs meet it.
No design files were changed.

I rendered `PART=1` from `tufty_handheld_shell.scad` with OpenSCAD 2021.01,
then inspected the rendered STL and the checked-in `back_shell.stl`. Both
measure 91.0 × 141.3 × 22.47 mm. OpenSCAD reports a simple solid; PrusaSlicer
reports the checked-in mesh manifold, one part, and 117,658 mm³ volume (the
rendered mesh measures 117,659 mm³). Point-in-mesh probes were made at both
lug slots and around the stick bay boundary. I also sliced the rendered part
with PrusaSlicer 2.7.2 using 0.20 mm layers, a 0.4 mm nozzle, 15% infill and
three perimeters. That is a reproducible comparison profile, not a
printer-specific production estimate.

## Item verdicts

| Item | Verdict | Evidence |
|---|---|---|
| Lug and slot geometry | **Pass** | Source and mesh give lug centres x = ±26 mm, profile y = 132.9…141.3 mm, width 16 mm, depth z = 4…18 mm, and 10 × 2.6 mm slots centred at y = 137.9 mm. At each lug, probes at the slot centre from z = 4.1 through 17.9 mm are void; probes 6.5 mm to either side, above the slot at y = 140 mm, and below it at y = 134 mm are solid. Thus both slots are genuinely through in Z, with 3 mm side walls, a 2.1 mm top bridge, and 3.7 mm of material below the slot to the y = 132.9 mm top wall. |
| Bay, base, and clearances | **Pass** | The lug profile starts at the stick bay's top inner face, y = 132.9 mm; a probe at y = 132.8 mm, z = 20 mm is void, while one above the bay at y = 133.0 mm is solid. There is no positive-volume lug intrusion into the bay. The rounded profile overlaps the shell's 2.4 mm top-wall band; its section at the top edge is about 15.88 mm wide × 14 mm deep (≈222 mm²), tapering to 10 × 14 mm (140 mm²) at its lower face. The rounded lug edge sits about 0.96 mm inside the shell outline at the top edge (the tightest point against the 10 mm corner radius). The nearest pilot-hole edge is about 4.86 mm from the rounded lug profile; the hole centre is (±35.5, 128.15) mm and the lug centre is (±26, 137.1) mm. |
| Bezel fit | **Pass** | The bezel is unchanged and ends at y = 135.3 mm. In the assembled coordinate system it occupies z = 22.47…24.87 mm; the lugs occupy z = 4…18 mm, so they do not intersect it. |
| Strength for wearing | **Conditional pass** | For a 150–190 g assembly, static load is 1.47–1.86 N total, or 0.74–0.93 N per lug if shared evenly. A 3 g walking swing is about 4.4–5.6 N total (2.2–2.8 N per lug). An illustrative 10 g catch is 14.7–18.6 N total (7.4–9.3 N per lug if shared); one lug could momentarily see the full load if the lanyard is uneven. At 20 g, the total is 29.4–37.3 N, or up to 37.3 N on one lug. The ≈222 mm² junction gives a nominal average of ≈0.08 MPa for a 10 g, 190 g single-lug catch (≈0.17 MPa at 20 g), before notch/contact effects. The 3 mm side walls, 2.1 mm top bridge, 3.7 mm lower ligament, and broad base are not obviously marginal for static hanging. With back-down printing, the main in-plane load path is within the layer plane; an out-of-plane pull can instead load layer bonds. The slot corners are square, and neither material nor print settings nor catch force is specified, so drop/snatch durability cannot be certified from the mesh. |
| Printability | **Fail — support-free claim** | The 14 mm lug depth starts at z = 4 mm, not at the bed-facing z = 0. The 6 mm rise above the shell's top edge therefore projects out from the top-wall footprint in the back-down orientation. A support-enabled PrusaSlicer run generated support/interface paths beneath both raised lug projections at z = 3.8 mm. Disabling supports still produces G-code, but does not demonstrate that this overhang will print reliably unsupported. |
| Dimensions and claims | **Pass** | Mesh bounds verify 91.0 mm width (including ribs), 141.3 mm height, and 22.47 mm depth; the body/bezel height remains 135.3 mm. The README's v3.1 lug dimensions, x positions, slot size, and overall dimensions match the source and mesh. Its approximately 91 × 141 × 25 mm assembled size is consistent with the back shell plus 2.4 mm bezel. |

## Findings, severity-ranked

### P2 — Back-down support-free printing is not established

The lug solids begin at z = 4 mm. Their upper 6 mm rise is outside the shell
outline, so the raised portion of those first lug layers has no shell directly
below it. The support-enabled slice has support/interface toolpaths beneath
both raised lug projections at z = 3.8 mm. A no-support slice can be generated,
but that is not evidence that the unsupported starts will adhere and form
sound lugs. Change the lug-to-shell geometry or print orientation, or specify
and accept supports; verify the chosen approach with a physical print.

### P3 — Impact strength needs a physical check

The nominal sections are substantial for the stated static load, and the
back-down layer direction is favorable for the main in-plane pull. However,
the 2.1 mm bridge and 3 mm side walls terminate at sharp slot corners, and
off-axis lanyard loads act across layer interfaces. A 10 g catch could put
14.7–18.6 N on one lug if the other is unloaded; at 20 g that rises to
29.4–37.3 N. The corresponding nominal stress at the ≈222 mm² junction is
about 0.08 MPa and 0.17 MPa for the 190 g case, respectively; this does not
capture stress concentration or impact/contact behavior. Actual peaks depend
on slack, drop distance, and lanyard compliance. Round the slot corners if the
design is revised, and test a printed part before relying on it for snatch/drop
loads.

## Slice estimate

With the comparison profile above and supports disabled, PrusaSlicer estimates
**6 h 41 min 48 s** and **57.96 cm³** of filament. At an assumed PLA density
of 1.24 g/cm³, that is approximately **72 g**. Enabling supports changes the
estimate to **6 h 46 min 56 s** and **58.79 cm³** (about **73 g**); this adds
support for other overhangs as well as the lug footprints. These are slicer
estimates, not measured print results. They are higher than the README's
approximate 5 h / 69 g guidance, but are not a like-for-like comparison because
the earlier printer profile and speeds are unspecified.

## Closing verdict

**Keep with changes.** The lug dimensions, slots, clearances, and basic static
load path are acceptable, but the back-down support-free claim is not
substantiated by the geometry: address the unsupported lug starts before
recommending this as a support-free print. Treat snatch/drop strength as
unverified until a representative print is tested.
