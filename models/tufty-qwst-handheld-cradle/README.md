# Tufty + Qw/ST Pad handheld cradle (first-fit concept)

This parametric OpenSCAD model explores a shared rear carrier for the supplied
Tufty 2350 case and the Qw/ST Pad in Pimoroni's printable case. The Tufty stays
in its stock case; the Pad is held below it with its buttons facing forward.
The sensor stick is intended to use Pimoroni's existing Badgeware sensor clip
in the badge's lanyard opening.

The design uses these source models as fit references:

- `../pimoroni-badgeware-blank/Badge_Case_Solid_w_Holes.stl`
- `../qwst-pad-game-controller-case/QwST Pad Casing Front.stl`
- `../qwst-pad-game-controller-case/QwST Pad Casing Back.stl`

Open `tufty_qwst_handheld_cradle.scad` in OpenSCAD. Set
`show_reference_models = 1` to preview the carrier with the reference models.
The STL files are not included again; keep this folder alongside the source
model folders in this repository.

## Known dimensions

- Tufty case blank: 84 x 76 x 21.37 mm, measured from the supplied Pimoroni STL.
- Qw/ST Pad case: 62 x 29 x 8.35 mm, measured from the supplied Pimoroni STLs.
- Qw/ST Pad PCB: approximately 58 x 25 x 6.7 mm; M2.5 holes 52 mm apart,
  approximately 3 mm from the upper corners (user supplied).
- Multi-Sensor Stick: 52 x 7.9 x 4.2 mm, M2.5 mounting holes (user supplied).

## Fit and safety notes

This is a first-fit concept, not a verified production part. The badge clip
stations and Pad retaining toes are intentionally exposed as parameters; inspect
the assembly preview and print a small clip test before printing the full
carrier. Check that the clips do not load the polycarbonate case's existing
snap features, controls, lanyard slot, ports, or rear access holes. Do not force
the clips over the case. Adjust the clearances for the printer and material.

The badge and Pad case meshes are reference solids and may not represent every
small detail of the physical cases. The sensor stick is not enclosed: preserve
airflow around the BME280 and leave the LTR559's light/proximity face exposed.

## Source model attribution

The Badgeware blank reference is by Pimoroni, under OCL v1.1 + GAtt v1. The
Qw/ST Pad case reference is by Pimoroni under BSD-2-Clause. Refer to the source
model folders and `../../licenses/` for the original terms. This cradle concept
is a separate, unfinished fit-test design; review applicable licences before
redistributing a derivative or bundled reference geometry.
