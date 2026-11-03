# Design review: Tufty handheld full shell v2

Review date 2026-10-31. Reviewed files on `main`: `tufty_handheld_shell.scad`, `back_shell.stl`, `front_bezel.stl` and `README.md`.
No test print was available, so every claim below comes from geometry measured in this repo's files. This is a review only; no design file was changed.

## Verdict: **Do not print yet**

Both STLs are clean, watertight, single-body meshes and they match the SCAD source. However, the part as drawn **cannot be assembled or used as intended**:

1. **The four M2.5 pilot holes do not exist in the back shell.** The bosses are filled solid, so the bezel cannot be screwed on (B1).
2. **No Qw/ST cable can reach the badge from either the pad or the stick, and the USB-C cutout opens into solid plastic.** The handheld cannot be wired or charged (B2, B3).

A print today would yield a back shell that holds the three boards but cannot close, connect or charge. It would also need supports under the whole palm-contact surface (M5). Fix the blockers, then decide on the majors, before spending the 5–7 h print.

---

## How the numbers were produced

| Tool | Use |
|---|---|
| OpenSCAD 2021.01 | Re-rendered `PART=1` and `PART=2` from source to compare against the shipped STLs |
| Python `trimesh` + `manifold3d` | Integrity, volumes, booleans, ray probes and sections |
| PrusaSlicer 2.7.2 (CLI) | Time and filament per orientation |

Placing the reference models:
- The ghost references were placed using the exact SCAD transforms:
  - Badge: `rotate([90,0,0])`, then translate `(0, 68.9, 17.59)`.
  - Pad: translate `(-29, 4.9, 18.44)`.
- The transforms were applied to the original Pimoroni STLs. Exporting the imported ghosts through OpenSCAD produces non-watertight meshes, so that route was not used.

Coordinate frame used throughout (the SCAD frame):

| Axis | Meaning | Range |
|---|---|---|
| X | Width | Centred, ±44.9 outer |
| Y | Height | 0 (bottom) … 127.3 (top) |
| Z | Depth | 0 back face … 24.6 front rim; bezel occupies 24.6 … 27.0 |

"Seated" means the badge resting on the back panel. The SCAD ghost floats 0.42 mm above the panel (`wall + 0.42` on line 122), so seated values are ghost values − 0.42.

Slicer profile used for every slice:

| Setting | Value |
|---|---|
| Nozzle | 0.4 mm |
| Layer height | 0.2 mm |
| Perimeters | 3 |
| Top / bottom solid layers | 5 / 4 |
| Infill | 15 % gyroid |
| Speeds | MK3S-class: 45 mm/s perimeters, 25 mm/s external, 80 mm/s infill, 1000–1250 mm/s² accelerations |
| Support threshold | 45° |

Masses use 1.24 g/cm³ for PLA and 1.27 g/cm³ for PETG, applied to PrusaSlicer's `filament used [cm3]`.

---

## 4. STL integrity (checked first, because everything else depends on it)

| | `back_shell.stl` | `front_bezel.stl` |
|---|---|---|
| Format | binary STL | binary STL |
| Triangles | **3,020** | **1,288** |
| Vertices (merged) | 1,512 | 632 |
| Watertight / consistent winding | yes / yes | yes / yes |
| Bodies | 1 | 1 |
| Degenerate faces | 0 | 0 |
| Euler characteristic → genus | 2 → 0 (no through-holes) | −12 → 7 (3 windows + 4 screw holes; the vent slots merge into the stick window) |
| Bounds (mm) | X −45.5…45.5, Y 0…127.3, Z −2.19…24.6 → **91.0 × 127.3 × 26.79** | **89.8 × 127.3 × 2.4** |
| Volume | **113,073.7 mm³** | **10,940.6 mm³** |
| Surface area | 42,447 mm² | 11,373 mm² |
| Matches fresh OpenSCAD render | yes (symmetric difference ≤ 0.07 mm³) | yes (≤ 0.07 mm³) |
| Mass if 100 % solid, PLA / PETG | 140.2 g / 143.6 g | 13.6 g / 13.9 g |

**Sliced mass and time** (realistic settings above):

| Part / orientation | Support | Est. time | Filament | PLA | PETG | Usable? |
|---|---|---|---|---|---|---|
| Back shell, back-down (as modelled) | none | 5 h 06 m | 57.08 cm³ | 70.8 g | 72.5 g | **No.** The flat back floats 0.2–2.2 mm above the bed (see M5) |
| Back shell, back-down | auto, `dont_support_bridges=1` | 6 h 02 m | 63.89 cm³ | 79.2 g | 81.1 g | Yes, but with a supported hand surface |
| Back shell, back-down | auto, bridges supported | 6 h 43 m | 69.37 cm³ | 86.0 g | 88.1 g | Yes, but with a supported hand surface |
| Back shell, front-down | auto, `dont_support_bridges=1` | 5 h 21 m | 58.54 cm³ | 72.6 g | 74.3 g | **No.** It leaves an 85 × 77 mm unsupported bridge |
| Back shell, front-down | auto, bridges supported | **7 h 45 m** | 90.43 cm³ | 112.1 g | 114.8 g | Yes, but wasteful (~30 % of extrusion is support) |
| *Back shell, back-down, `swell_depth=0` (comparison render in /tmp only)* | *none* | *5 h 08 m* | *55.74 cm³* | *69.1 g* | *70.8 g* | *Yes. Recommended* |
| Front bezel, flat | none | **58 m** | 9.91 cm³ | **12.3 g** | **12.6 g** | Yes |

The STLs themselves are fit to slice. The problems are in the geometry they encode.

---

## Findings, severity-ranked

### Blockers

#### B1. Screw pilot holes are filled solid, so the bezel cannot be fastened

- **Where:** `back_shell()` lines 171–182. Each boss is drawn as `difference(){ cylinder(d=6.5); cylinder(d=2.2); }`.
- **Why it fails:** that difference is then **unioned** with the slab. The slab is already solid at all four boss positions:
  - (±35.5, 17.4) lies in the side margin beside the pad bay. The pad bay spans x ±31.5 at z ≥ 15.2 and has solid material behind it.
  - (±35.5, 120.15) lies in the margin beside the stick bay. The stick bay spans x ±26.75 at z ≥ 19.0.
  - The union therefore refills each hole.
- **Evidence:**
  - I ray-probed the hole axis at 49 depth samples (z 0.25…24.35) for each boss. All **49/49 samples were inside material for all four bosses**.
  - The back-shell mesh has genus 0, meaning there are no through-holes anywhere.
  - The bosses also add nothing to the shell. Unioning them is a no-op, because they lie wholly inside material that already exists.
- **Bezel side:** the bezel clearance holes do exist. They are Ø2.9 at the same (±35.5, 17.4/120.15) and are confirmed through by probing. Alignment of the two parts is correct by construction, since both use `boss_x_*` / `boss_y_*`. Only the shell side is missing.
- **Fix (exact):**
  - Delete the boss `for` loop (lines 171–182). It contributes no material.
  - Inside the top-level `difference()` of `back_shell()`, add blind pilot holes from the front face:
    `for (sx=[-1,1], yy=[boss_y_top, boss_y_bot]) translate([sx*boss_x_top, yy, shell_d-10]) cylinder(d=boss_hole, h=10.1);`
  - This gives 10 mm-deep holes at z 14.6–24.6.
- **Wall left around each new hole** (hole radius 1.1 mm):

| Hole | Nearest feature | Wall |
|---|---|---|
| Bottom (±35.5, 17.4) | Pad bay wall | 35.5 − 31.5 − 1.1 = **2.9 mm** |
| Bottom (±35.5, 17.4) | Outer wall | ≥ 6.7 mm |
| Top (±35.5, 120.15) | Stick bay | **7.65 mm** |
| Top (±35.5, 120.15) | Badge bay (top at y 112.4) | **6.65 mm** |
| Top (±35.5, 120.15) | Outer surface (10 mm corner radius and 1.6 mm front chamfer) | **≈ 4.4 mm** at the face |

- **Screws:** use M2.5 × 8 thread-forming (or M2.5 × 10 with the 10 mm hole). Engagement = 8 − 2.4 = 5.6 mm, which is about 2.2 × d and adequate in PLA/PETG.

#### B2. Qw/ST "pass-throughs" are blind pockets, and there is no room for a plug at the pad or the stick

- **Where:** lines 156–157. The README says the slots are "cut through both divider webs".
- **Where the pockets actually sit:**

| Pocket | Extent | Opens into | Fails to reach |
|---|---|---|---|
| Pad ↔ badge (`box_at(20, 33.9, 5.9, 16, 5, 7)`) | x 12…28, y 31.4…36.4, **z 2.4…9.4** | Badge bay | Pad bay floor at **z 15.2**. Its pad end runs into 5.8 mm of solid material. |
| Stick ↔ badge (`box_at(-18, 113.9, 5.4, 10, 5, 6)`) | x −23…−13, y 111.4…116.4, **z 2.4…8.4** | Badge bay | Stick bay floor at **z 19.0** (10.6 mm of solid). |

- **Evidence:** ray probes from each pocket toward the pad and stick bays hit solid. The shell mesh has genus 0, so there is no hole of any kind through it.
- **Plug room, even with real through-slots:**
  - The pad case's Qw/ST connector opening is in its **top wall facing +y**, near x ≈ 9…11 from the centre line, at z ≈ 20.5…22.5 (ghost frame).
  - The pad case top face sits at y 31.9. The divider starts at y 32.4. That leaves **0.5 mm in front of the connector**, against the ≈ 8 mm a JST-SH plug body plus cable bend needs.
  - The stick bay is 53.5 mm long for a 52 mm stick, which is **0.75 mm per end**.
- **Fix (minimum geometry; the owner must choose the layout):**
  - Write the notches below in the SCAD's derived variables, not literal numbers, so they stay correct after the depth changes in M2/M3. Current values are given in brackets.
  - **Pad:** provide ≥ 8 mm of free +y space in front of the pad connector. The simplest way is `pad_cav_h = pad_h + 2*clearance + 8`: outer height 127.3 → 135.3 mm, and `y_badge`, `y_stick` and `boss_y_top` all shift +8 mm automatically. Then notch the divider from the front: x = connector ±6 mm, y `y_badge − divider` … `y_badge` [32.4…35.4 today], z `shell_d − pad_cav_d` … `shell_d` [15.2…24.6 today]. Do not use a rear pocket.
  - **Stick:** if its Qw/ST connectors are on the short ends (verify on the real board), lengthen `stick_cav_l` from 53.5 to **≥ 61 mm**. That still clears the top bosses: 61/2 = 30.5, against the 32.25 mm boss inner edge. Notch the divider over y `y_stick − divider` … `y_stick` [112.4…115.4 today], z `shell_d − stick_cav_d` … `shell_d` [19.0…24.6 today].
  - Where the badge's own Qw/ST socket is cannot be determined from the buck (see Known unknowns). The badge-bay end of both routes must be placed after measuring a real Tufty.
  - Delete the two rear pockets.

#### B3. The USB-C cutout opens into 32 mm of solid plastic, so the badge cannot be charged or reflashed in the shell

- **Where:** line 159, `box_at(0, 1.2, shell_d/2, 12, wall+2, 5)`. This is a pocket at x ±6, z 9.8…14.8, y −1…3.4 in the **bottom wall of the pad zone**.
- **Evidence:**
  - The pocket is only **3.4 mm deep**. Behind it is solid material all the way to the badge bay at y 35.4, about 32 mm away.
  - The badge's own edge is at y 35.9 seated, 32.5 mm from the outer wall.
  - The pocket's top (z 14.8) is 0.4 mm below the pad bay floor (z 15.2) over y 2.4…3.4. That leaves a **0.4 mm membrane**, which will print as a ragged one-layer skin.
- **Fix:** delete the pocket. Once the badge's USB-C position is measured, cut a 12 × 7 mm opening (USB-C overmould clearance) **through the wall directly opposite the badge's port**, at the port's measured z. Use `box_at(x_port, y_wall, z_port, 12, 2*wall+2, 7)` on the relevant badge-bay wall.
- **Candidate position:** the buck shows one asymmetric feature, a boss on its left flank at x → −41.9, y 62.4…75.4, z 11.2…13.6 seated. That is the only candidate visible in the files. It is **unverified**.
- **Charging inside the shell is impossible without this fix.** With B2 also open, so is any use of the pad or stick.

### Major

#### M1. Spring clips are rigid, interfering blocks: a permanent wedge, not a snap

- **Geometry:** lines 163–168.
  - Four blocks at x ±(41.4…42.9), y 58.5 / 89.3 (centres; each 9 mm tall), z **17.6…22.6**.
  - Each protrudes **1.1 mm** from the bay wall (x 42.5).
  - The badge's widest "belt" is at half-width **42.0**, so the interference is **0.6 mm per side**.
  - In `PART=0`, each clip overlaps the badge ghost by **13.0 mm³** (52.2 mm³ total) over z 17.6…20.95.
- **The clips never snap.** Seated, the badge flank half-width at each clip measures (same at y 58.5 and y 89.3):

| z (seated) | 17.0 | 18.0 | 19.0 | 20.0 | 20.5 | 21.0 | 22.0 |
|---|---|---|---|---|---|---|---|
| Half-width (mm) | 42.00 | 41.97 | 41.88 | 41.62 | 41.42 | 41.16 | 40.14 |

- **What that means for the fit:**
  - The flank stays wider than the clip face (41.4) from the belt up to **z ≈ 20.5**.
  - So the clip's lower 2.9 mm (z 17.6…20.5) bears on the badge flank the whole time it is seated, with up to 0.6 mm deflection. There is no undercut for it to drop into.
  - Retention is purely a friction wedge. Its force decays as PLA/PETG creeps.
  - The clips have no lead-in; the flat 1.1 mm step meets the badge's tapered back.
- **Stiffness (hand calculation):**
  - The "spring" is the whole 2.4 mm side wall, cantilevered from the back panel. Lever arm L = 15.2…20.2 mm, effective width 9…30 mm.
  - Force for 0.6 mm deflection: **8–62 N per clip in PLA** (E ≈ 3.5 GPa). PETG is about 0.57× that.
  - Root strain is 0.53–0.94 %, about 33 MPa in PLA. When printed back-down, that stress runs **across layer lines** at a root that is only **1.28 mm thick** (see M6). Typical PLA interlayer strength is 20–35 MPa.
  - Expect a whitened or cracked root, or a badge that has to be forced in and pried out.
  - With μ 0.3–0.4, four clips need roughly **22–100 N of push through the LCD face** to insert.
  - The two clips per side also differ: grip ribs (y 12.3…71.7) stiffen the wall at the lower clip only.
- **Fix (pick one, exact):**
  - **A (simplest, recommended):** set `clip_proud = 0` (delete the clips). Retain the badge with the bezel lips plus rear standoffs (M4), and the 0.5 mm side clearance. The badge is then captured front–back between the standoffs and the bezel. Close the front gap with M3.
  - **B (real snap, if one is wanted):** for each clip:
    1. Cut two **1.0 mm through-slots** in the side wall at y = clip centre ± 4.0…5.0, from z 24.6 down to **z 6.6**. This creates an **8 mm-wide tongue, 18 mm long**.
    2. Thin the tongue from inside to **1.6 mm** (x 43.3…44.9).
    3. Trim its free end to z ≤ 24.0, so the bezel does not pinch it.
    4. Add a catch: tip at **x 41.3, z 20.7…21.2**. Rear (retaining) face at 45° from (41.3, 20.7) to (43.3, 18.7). Front lead-in ≈ 35° from vertical, from (41.3, 21.2) to (43.3, 24.0).
  - **What B achieves:**
    - Insertion deflection is 0.7 mm. That gives ≈ 0.5 % strain and **≈ 3.4 N per finger in PLA** (2.0 N in PETG).
    - Seated, the tip sits over the badge flank where it narrows from 41.42 to 41.16 mm (z 20.5…21.0). The finger relaxes to ~0 mm, and its 45° face bears on the tapered shoulder, pushing the badge back.
    - The slots will cut the ribs at y 54.3…57.7 and 61.3…64.7.
  - Verify B against a real case before relying on it. The buck may not match the moulded PC case flank.
  - **B is only valid if the bay depth stays at 22.2 mm** (`shell_d` = 24.6). The catch and lead-in coordinates are absolute, because the seated badge does not move. The M2 depth change puts the rim at z 22.47, below the 24.0 lead-in top and only 1.27 mm above the catch. B and the M2 depth change are therefore mutually exclusive. With the M2 fix, the bezel lip already retains the badge face, so use **A**.

#### M2. Every badge button is partly covered by the bezel lip, and the button caps are the only forward stop

- **Window:** 76 × 68 mm at x ±38, y 39.9…107.9 (line 204). That leaves a **4.5 mm lip from the cavity wall, 4.0 mm over the badge outline**.
- **Buttons:** the buck models five 6.8 × 6.8 mm button caps, raised 1.6 mm.

| Buttons | x | y | Under lip |
|---|---|---|---|
| 3 bottom | −18 / 0 / 18 | 38.5…45.3 | **1.4 mm** (y 38.5…39.9) |
| 2 right side | 32.6…39.4 | 56.5…63.3 and 74.5…81.3 | **1.4 mm** (x 38…39.4) |

- **Consequence:**
  - Seated, the badge face plane is at z 22.27, 2.33 mm behind the bezel's inner face.
  - The cap tops are at z 23.77, only **0.83 mm** behind it.
  - So the first thing the bezel touches when the badge moves forward is the **buttons**: in a drop, under clip wedge (M1), or with a thicker real case.
  - In use, each cap shows only 5.4 mm of its 6.8 mm inside a **3.23 mm-deep well** (bezel front at 27.0).
- **Fix (exact):**
  - Keep the 76 × 68 window and its 4.0 mm lip over the badge outline. Cut **8.8 × 8.8 mm through-notches** in the bezel, centred on each of the five caps: (−18, 41.9), (0, 41.9), (18, 41.9), (36.0, 59.9) and (36.0, 77.9). That gives 1.0 mm clearance around each cap.
  - Make the **case face**, not the buttons, the forward stop. Set `badge_cav_d = badge_d - 1.3` (22.2 → 20.07). The seated face plane sits 19.87 mm above the back panel, so this leaves a **0.2 mm** face-to-bezel gap. The bezel underside moves to z 22.47, so the cap tops (z 23.77) rise 1.3 mm into the notches. They end **1.1 mm** below the bezel front (z 24.87), instead of 3.23 mm.
  - Moving the front rim back also moves the shallow pad and stick bays back, since they are cut from the front. There is solid material behind both, so the printed parts need no other change.
  - In the preview, `pad_ghost()` uses an absolute z of 18.44 (lines 131–134). Change it to `18.44 - (24.6 - shell_d)` (or rewrite it relative to `shell_d`). Otherwise `PART=0` will show a false pad/bezel interference. The badge ghost is referenced to the back panel and the stick ghost to `shell_d`, so neither needs changing.
  - Do **not** simply widen the window to clear the caps. The face's rounded edge is at a half-width of only ≈ 40.0 mm (flank 40.14 at z 22.0), so a window wider than x ±40 leaves no lip over the face at the sides.

#### M3. No positive front–back location for the badge, pad or stick (rattle / rocking)

| Board | Seated position | Front gap | Result |
|---|---|---|---|
| Badge | The domed back touches the back panel at one area only. The lowest point is (−6, 41.5) and only ≈ 110 mm² lies within 0.5 mm of it. | 0.83 mm | It can rock about that point and slide 0.83 mm forward. |
| Pad | Sits on the bay floor (z 15.2); its front is at 23.55 | 1.05 mm | Rattles |
| Stick | Bay is 5.6 deep for a 4.2 mm board | 1.4 mm | Rattles |

- **Fix:**
  - **Badge:** add rear standoffs. Use four Ø4 mm posts at (±37.5, 47) and (±37.5, 90), rising from the back panel (z 2.4) to **z 13.57**. That height is the measured seated badge-back height at all four points, where the case shoulder is flat. Together with the `badge_cav_d` change in M2, the badge is then held between four standoffs and the bezel lip, with 0.2 mm of play.
  - **Pad:** `pad_cav_d = pad_d + 0.2` (9.4 → 8.55).
  - **Stick:** `stick_cav_d = stick_t + 0.3` (5.6 → 4.5), or add 1.0 mm crush ribs.

#### M4. Tufty BOOT and RESET buttons and the rear lighting are sealed behind a solid back

- **Source:** the official `pimoroni/tufty2350` README (lines 51–53 and 61–62): "Turn your badge around so the back is facing you. Press and hold the BOOT button… tap the RESET button". RESET double-tap is also used for app installation. The same README lists "Four-zone rear lighting".
- **Problem:** the shell's back panel is a continuous 2.4 mm sheet (plus the swell) over the full 85 × 77 bay. Reflashing or installing apps means unscrewing the bezel and removing the badge, which then fights the clips (M1).
- **Fix:** add access holes once the real button positions are measured. Ø6 mm through-holes in the back panel are big enough for a paperclip or fingertip on a recessed button. Optionally add a rear window or light pipes for the lighting zones. Positions cannot be derived from the buck (see Known unknowns).

#### M5. The palm swell forces support under the whole hand-contact back

- **Geometry:** the swell (lines 184–189) is an ellipsoid cap with a **45.1 × 60.1 mm** footprint, 2.19 mm proud, centred at y 58.6. Its apex is the lowest point of the part.
- **Back-down:**
  - The part stands on **31 mm²** (the dome apex). The other **9,637 mm²** of flat back sits 0.5…2.5 mm above the bed and is a downward-facing surface that needs support.
  - Slicing without support still "succeeds" (5 h 06 m), but that flat area would print in mid-air.
  - With support: 6 h 02 m – 6 h 43 m, 7–12 cm³ of support, and a support-scarred surface right where the hand goes.
- **Front-down:**
  - Bed contact is 1,743 mm². But the bay floors become ceilings:
    - Badge bay (85 × 77): **6,649 mm²** of overhang at height 20…23 mm (85 × 77 = 6,545, plus clip undersides).
    - Pad bay (63 × 30) and stick bay (53.5 × 9.5): **2,398 mm²** at height 5…10 mm (1,890 + 508).
  - Total 7 h 45 m and 90.4 cm³, of which about 30 % is support.
- **Swell removed** (`swell_depth = 0`): back-down bed contact rises to **10,122 mm²**, with **no support needed**: 5 h 08 m, 69.1 g PLA.
- **Fix:** set `swell_depth = 0` and print back-down. If the swell is wanted, print it as a separate 2.2 mm cap and glue it on. It adds only 2.2 mm over a 45 mm span (see E1), so the ergonomic gain is small.

#### M6. Thin structural sections at the clip root and front rim

| Section | Measured on `back_shell.stl` | Why it matters |
|---|---|---|
| Inner corner of the badge bay (42.5, 2.4) to the 3 mm back chamfer | **1.28 mm** normal thickness, at every y from 35.4 to 112.4, including both clip positions | This is the root of the side-wall "spring" (M1): about 3 perimeters, carrying the bending stress across layers. |
| Side wall at z 24.5, beside the badge bay | **0.91 mm** (0.8 mm at z 24.6, where the 1.6 mm front chamfer meets the 2.4 mm wall) | The bezel seats and is screwed onto this edge. It prints as 2 perimeters and will chip. |

- **Fix:**
  - Reduce `edge_bevel_back` from 3.0 to **1.5** (root → **2.33 mm** normal thickness: the distance from (42.5, 2.4) to the chamfer line x − z = 43.4 is 3.3/√2).
  - Reduce `edge_bevel_front` from 1.6 to **0.8** (rim → 1.6 mm).
  - Or increase `wall` to 3.0 at the cost of 1.2 mm in width.

### Minor

| # | Finding | Evidence | Change |
|---|---|---|---|
| m1 | The M2.5 screw heads stand proud | Bezel holes are plain Ø2.9 with no counterbore. An M2.5 pan head (~Ø4.5 × 1.7) sits 1.7 mm proud. | Ø5.0 × 1.2 mm counterbore (leaves 1.2 mm under the head), or use M2.5 countersunk screws with a 90° × Ø5.0 countersink |
| m2 | The pilot hole may be tight in PETG | Ø2.2 typically prints at about Ø2.0–2.1 vertically | Keep 2.2 for PLA; use **2.3–2.4 for PETG** |
| m3 | The bezel "vent slots" are not separate vents | The 7 × 2.2 slots at x ±22 overlap the 44 × 5.5 stick window (x ±22) and merge into notches at its ends. Bezel genus 7, not 9. | Drop the vents, or replace the window with one 52 × 5.5 slot (the full stick length) if the BME280 sits at a stick end. Moving them outward is not possible, because the stick bay ends at x ±26.75 and solid rim lies beyond it. |
| m4 | Rib count and coverage are wrong in the README | `[14:7:76]` gives **9 ribs per side (18 total)**, not "10". They span y 12.3…71.7, so they cover 47 % of the 127.3 mm height and stop at 56 % of it, not the "lower two-thirds". They stand 0.6 mm proud. | Fix the README, or use `[14:7:84]` for 11 ribs to y 85.7 (67 %) |
| m5 | Back shell height is mis-stated in the README | Measured 26.79 mm (README says 26.7) | Change to 26.8 |
| m6 | The ghost comment is wrong | Line 120 says the ghost badge sits "upside-down". In the ghost, the 3 face buttons are at the bottom, 2 on the right, and the lanyard tab (y 101–112) at the top, so it is **upright**. | Fix the comment |
| m7 | The pad window overlaps the pad case's chamfered edges | The window is 55 × 22 (x ±27.5, y 6.4…28.4) over the 62 × 29 pad face, so 3.5 mm lips. The cross-shaped control openings (x ±6.75…26.25, y 7.6…27.15) clear the window by **1.20–1.25 mm**, but the lip overhangs the outer ~1.1 mm of each opening's 2 mm chamfer. | Optional: grow the window to 57.5 × 24.5 to clear the chamfers |
| m8 | 0.4 mm membrane over the USB pocket | See B3 | Removed by the B3 fix |
| m9 | Mass sits in solid blocks behind the shallow bays | Model volume 113.1 cm³. Solid zones: behind the pad bay (z 0…15.2 over ≈ 90 × 32 mm) and behind the stick bay (z 0…19 over ≈ 85 × 12 mm). | Optional: core the pad-zone block with a 59 × 26 × 11 mm void (−16.9 cm³ of model volume). The printed saving at 15 % infill is small and was not sliced. The real value is that the void provides the cable room B2 needs. |

---

## 1. Fit / interference summary

| Board | Bay (W × H × D, mm) | Board | Clearance per side (W / H / depth) | Interference in PART=0 |
|---|---|---|---|---|
| Tufty in stock case | 85 × 77 × 22.2 | 84 × 76 × 21.37 | 0.5 / 0.5 / 0.83 | **Clips: 4 × 13.0 mm³** (M1). Otherwise none. |
| Qw/ST Pad in case | 63 × 30 × 9.4 | 62 × 29 × 8.35 | 0.5 / 0.5 / 1.05 | 0. Front and back halves do not overlap each other or the shell. |
| Multi-Sensor Stick | 53.5 × 9.5 × 5.6 | 52 × 7.9 × 4.2 | 0.75 / 0.8 / 1.4 | 0 (bounding-box ghost) |

- **Badge insertion path:**
  - The badge goes in from the front, back first, before the bezel is fitted. The entire 84 mm belt (z 16.1…18.1 seated) has to pass the clip faces at 41.4 mm half-width, which is a 0.6 mm per-side interference.
  - Nothing else obstructs the path. The bay is open over its full 85 × 77 face, and the bosses and pockets lie outside the bay outline.
  - So the badge *can* physically get in, but only by bending each side wall 0.6 mm and leaving it bent (M1).
  - Removal has no grip point, because the bay is 22.2 mm deep with 0.5 mm side gaps. Option A in M1 addresses this; with option B, add two 15 × 3 mm finger notches in the front rim at x = 0.
- **Assembly order** with the current design works geometrically: pad → stick → badge → bezel. But the bezel cannot be screwed down (B1), and no cables can be connected (B2).

## 2. Spring clips

They cannot work as drawn. See **M1**: there is no undercut, so they act as a permanent 0.6 mm wedge rather than a snap. The stiffness comes from the whole side wall, at a root only 1.28 mm thick, loaded across layers. The exact replacement geometry (option B) and the recommended deletion (option A, plus the standoffs in M3) are specified there.

## 3. Fasteners

- **Positions:** the bezel holes and the boss positions coincide by construction, at (±35.5, 17.4) and (±35.5, 120.15). Screw spacing is 71.0 mm in x and 102.75 mm in y.
- **Pilot holes:** missing (**B1**).
- **Sizing:** Ø2.2 for M2.5 thread-forming is appropriate in PLA. Open it to 2.3–2.4 for PETG (m2).
- **Bosses:** the 6.5 mm OD bosses (2.15 mm wall) are redundant, because each hole will sit inside a solid margin. The tightest wall after the B1 fix is **2.9 mm** to the pad bay.

## 5. Printability

| Part | Recommended orientation | Support | Notes |
|---|---|---|---|
| Back shell, after the M5 fix | **Back face down** | None | See below |
| Back shell, as-is | Back-down with support from the build plate | Yes | Expect a scarred palm surface; 6 h 02 m – 6 h 43 m |
| Front bezel | Flat, either face down | None | See below |

**Back shell, after the M5 fix (back-down, no support):**
- Remaining overhangs are all printable without support:
  - Clip undersides: 1.1 mm (or 0 after M1 option A).
  - Rib undersides: 0.6 mm.
  - The 45° back chamfer.
  - Pocket ceilings bridging 10–16 mm (removed by B2).
- **Do not print front-down.** The 85 × 77 mm badge-bay ceiling needs 30 cm³ of internal support.

**Front bezel (58 min, 12.3 g PLA):**
- The 0.9 mm chamfers on both faces are 45°.
- The narrowest strip is the 6.9 mm side strip beside the badge window. There are no thin features.
- Use the face that will show as the top surface.

**Failure-prone features, as drawn:**
1. Swell-induced support under the back (M5).
2. The 0.8–0.91 mm front rim chipping (M6).
3. The 0.4 mm membrane over the USB pocket (B3/m8).
4. Clip roots cracking during badge insertion (M1/M6).
5. Elephant's foot on the 45° back chamfer is harmless.

**Time drivers:**
- About 123 layers at 0.2 mm, each containing the full 91 × 127 perimeter plus the bay outlines.
- Per the feature breakdown of the support-free shell slice, the main contributors are:
  - Solid infill ≈ 27 %, mostly the large solid back panel under the badge bay. Top and bottom skins are 5 / 4 layers over most of the 2.4 mm back.
  - Perimeters plus external perimeters ≈ 38 %.
  - Sparse infill in the solid blocks behind the shallow pad and stick bays ≈ 21 %.
- Support adds 1 h – 2 h 40 m depending on orientation.
- Dropping to 0.28 mm layers would cut roughly 25–30 % of the time, at the cost of a visible stair-step on the chamfers.

## 6. Known unknowns (cannot be verified without a real Tufty)

| Item | What the files show | Status |
|---|---|---|
| **Display position vs the 76 × 68 window** | The buck face is a flat plane. The official spec is a 2.8" 320×240 IPS. A typical 2.8" 4:3 panel has an active area ≈ 57.6 × 43.2 mm. If centred on the 84 × 76 case, that leaves ≈ 9.2 mm (sides) / 12.4 mm (top/bottom) of margin inside the window. | **Unverifiable.** Plausible fit if centred, but no published drawing gives the offset. |
| **4.5 mm window lips vs published Tufty dimensions** | No dimensioned drawing was found in `pimoroni/tufty2350` (the README lists specs only) or elsewhere reachable. Pimoroni shop and docs pages were unreachable from the review environment. An external summary gives 84 × 76 × 20 mm; the buck is 21.37 deep including 1.6 mm button caps → 19.77 mm body, which is consistent. | Outline confirmed. **Face features unconfirmed**, apart from the buck's button caps (M2). |
| **USB-C position** | The candidate in the SCAD is a dead end (B3). The only asymmetric feature on the buck is the left-flank boss at x −41.9, y 62.4…75.4, z 11.2…13.6 (seated). An external summary claims USB-C and Qw/ST are on the top edge. Both are unverified, and they disagree. | **Unverifiable** |
| **Badge Qw/ST socket position** | Not modelled on the buck | **Unverifiable.** Blocks finishing B2. |
| **BOOT / RESET / rear lighting positions** | They are on the back per the official README. Positions are not given. | **Unverifiable.** Needed for M4. |
| **Multi-Sensor Stick sensor positions (LTR559, BME280) vs the 44 × 5.5 window and the vents** | The ghost is a 52 × 7.9 × 4.2 bounding box, centred. The window spans the middle 44 mm (x ±22), leaving 4 mm uncovered at each end. Whether the BME280 sits under the merged vent notches at x ±22…25.5 depends on the real board layout. | **Unverifiable** |
| **Stick Qw/ST connector location** | Not modelled | **Unverifiable.** Needed for B2. |
| **Real PC case flank vs the buck** | The clip analysis (M1) uses the buck flank profile | Verify before using clip option B |

Before the next revision, measure on a real badge:
- Display active-area offset.
- Button centres.
- USB-C, Qw/ST, BOOT and RESET positions and heights.
- Stick connector and sensor positions.

## 7. Ergonomics

| Quantity | Value |
|---|---|
| Assembled envelope | **91.0 × 127.3 × 29.2 mm** (shell 26.79 + bezel 2.4; ribs give the 91.0 width) |
| Printed mass, PLA (sliced) | Shell 70.8 g (69.1 g without the swell) + bezel 12.3 g = **≈ 83 g** (PETG ≈ 85 g) |
| Screws | 4 × M2.5 × 8 steel ≈ 2 g |
| Qw/ST Pad case (printed) | Solid volume 5.48 cm³ → ≤ 6.8 g PLA, plus the pad PCB (not weighed) |
| Tufty 2350 in stock case | **Not measurable from files.** Estimate 60–90 g, including the 1,000 mAh LiPo (~20 g). |
| **Estimated total in hand** | **≈ 150–190 g** |

That is about the size of an original Game Boy (≈ 90 × 148 × 32 mm, ≈ 220 g with batteries), so size and weight are reasonable for two-handed portrait use.

Things that make it **worse** to hold or use:

| # | Issue | Severity |
|---|---|---|
| E1 | **The palm swell rocks on a table.** The resting contact is the 31 mm² dome apex; the flat back is 2.19 mm up. Pressing badge or pad buttons with the unit on a desk will tilt it. A 2.2 mm rise over a 45 mm width (≈ 5.6° edge slope) is barely felt in the palm, so it costs more (support, rocking) than it gives. | Minor (cost driver in M5) |
| E2 | **Recessed controls.** The pad case face sits 3.45 mm below the bezel front (1.05 mm gap + 2.4 mm bezel). The badge button tops sit in 3.23 mm wells, partly covered (M2; 1.1 mm wells after the M2 fix). Thumbs work through 2.4 mm-thick 4 mm lips. | Major for the badge buttons (in M2); minor for the pad, which improves with the M3 depth fix (well → 2.6 mm) |
| E3 | The grip ribs are 0.6 mm-proud square bars on 7 mm pitch, only on the lower 47 % of the height. They add little grip, and their sharp 90° edges sit under the fingers. | Minor. Round them to r 0.3, or replace with 0.4 mm knurl. |
| E4 | The 10 mm corner radii and the 3 mm / 1.6 mm chamfers do improve hand feel. But they cause the thin sections in M6. | Covered by M6 |
| E5 | Weight balance: the badge (heaviest, with its battery) sits in the middle-to-top of the body (y 35.9…111.9) and the pad at the bottom, so the unit is top-heavy in a portrait thumb grip on the pad. This is acceptable at < 200 g. | Note only |

---

## Change list for "print with changes" (in priority order)

1. **B1:** delete the boss loop (lines 171–182). Subtract 4 × Ø2.2 (PLA) / Ø2.3–2.4 (PETG) blind holes, 10 mm deep from the front face, inside the main `difference()`.
2. **B2:**
   - Delete the rear pockets (lines 156–157).
   - Set `pad_cav_h = pad_h + 2*clearance + 8`, then notch the divider from the front (x connector ±6; y `y_badge − divider`…`y_badge`; z `shell_d − pad_cav_d`…`shell_d`).
   - Set `stick_cav_l ≥ 61`, then notch the divider (y `y_stick − divider`…`y_stick`; z `shell_d − stick_cav_d`…`shell_d`).
   - Place the badge-side ends after measuring the badge's Qw/ST socket.
3. **B3:** delete line 159. Cut a 12 × 7 mm through-opening opposite the measured badge USB-C port.
4. **M1:** `clip_proud = 0` (recommended), or the exact cantilever finger spec in M1 option B.
5. **M3:**
   - 4 × Ø4 standoffs at (±37.5, 47) and (±37.5, 90), z 2.4 → 13.57.
   - `pad_cav_d = pad_d + 0.2`.
   - `stick_cav_d = stick_t + 0.3`.
   - Rebase `pad_ghost()` z on `shell_d` (preview only).
6. **M2:** 8.8 × 8.8 mm bezel notches over the five buttons, and `badge_cav_d = badge_d - 1.3` so the case face, not the buttons, is the forward stop.
7. **M4:** Ø6 rear access holes for BOOT and RESET at the measured positions.
8. **M5:** `swell_depth = 0`. Print back-down without support (≈ 5 h 08 m, 69 g PLA shell + 58 min, 12 g bezel).
9. **M6:** `edge_bevel_back = 1.5`, `edge_bevel_front = 0.8`.
10. **Minor:** counterbore the bezel holes (m1), move or drop the vents (m3), fix the README rib/height text and the SCAD ghost comment (m4–m6).

Items 1–3 are required before any print is useful. Items 2, 3, 6 and 7 also need measurements from a real Tufty 2350 and Multi-Sensor Stick. Item 6's notch centres come from the buck's button caps and must be confirmed on a real badge, which is why the verdict is **do not print yet** rather than "print with changes". Once those measurements exist and items 1–8 are applied, a single back-down print of the shell (no support) plus the bezel is a sensible first test print.
