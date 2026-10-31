// Tufty 2350 handheld — FULL SHELL case (v3.1: v3 review fixes + lanyard lugs)
// =====================================================================
// A complete two-part shell that houses all three boards at once:
//   * Tufty 2350 (in its stock polycarbonate case) — rests on four rear
//     standoffs in the badge bay, retained by the front bezel's lips
//   * Qw/ST Pad (in Pimoroni's printable case) — lower bay, D-pads and
//     buttons facing forward through the bezel window
//   * Multi-Sensor Stick — top bay, sensor face forward behind a
//     full-length bezel window
// Parts: back_shell (PART=1) and front_bezel (PART=2), joined by
// 4x M2.5 x 8 screws into blind pilot holes in the back shell.
//
// v3 applies every fix from the Copilot design review (REVIEW.md,
// PR #2, verdict "do not print yet") that does NOT need measurements
// from a physical badge:
//   B1 boss loop deleted; real Ø2.2 blind pilot holes (10 mm deep)
//      subtracted in the main difference.
//   B2 blind rear pockets deleted; pad bay height +8 mm for Qw/ST plug
//      room; stick bay lengthened to 61.5 mm; divider notches cut from
//      the FRONT of both divider webs so cables can actually pass.
//   B3 dead-end USB pocket deleted (real opening awaits a measured
//      port position — see README).
//   M1 spring clips deleted (option A). Badge is located by standoffs
//      (M3) + bezel lips instead of a friction wedge.
//   M2 8.8 mm bezel notches over the five button caps (positions from
//      the buck's modelled caps) and badge_cav_d = badge_d - 1.3, so
//      the case face — not the buttons — is the forward stop.
//   M3 four Ø4 standoffs (tops at the review-measured z 13.57 in the
//      v1 frame, rebased on y_badge); pad_cav_d = pad_d + 0.2;
//      stick_cav_d = stick_t + 0.3.
//   M5 palm swell removed (swell_depth = 0): print back-down, no
//      support under the hand surface; no table-rocking.
//   M6 edge_bevel_back 3.0 -> 1.5, edge_bevel_front 1.6 -> 0.8
//      (bay-corner root 1.28 -> ~2.33 mm; front rim 0.91 -> ~1.6 mm).
//   m1 bezel screw holes get a Ø5.0 x 1.2 counterbore.
//   m3 stick window is now one full-length 52 x 5.5 slot (the old
//      "vent slots" merged into the window anyway).
// v3.1 (user request): two lanyard lugs on the top edge of the back
// shell (x ±26, each with a 10 x 2.6 mm through-slot) so the unit can
// still be worn as a badge. Overall height 135.3 -> 141.3 mm. The
// badge's own lanyard tab stays enclosed — the stick bay is above it.
// STILL PENDING HARDWARE MEASUREMENTS (see README): badge USB-C and
// Qw/ST socket positions, BOOT/RESET positions (M4 rear holes),
// button-centre confirmation for the M2 notches, stick connector end
// and LTR559/BME280 positions.
//
// Reference dimensions (measured 2026-10-31 from Pimoroni's own STLs
// in github.com/Mike-Demo/pimoroni-badgeware-printables):
//   Badgeware badge-in-case solid : 84.0 x 76.0 x 21.37 mm
//   Qw/ST Pad case (assembled)    : 62.0 x 29.0 x ~8.35 mm
//   Multi-Sensor Stick            : 52.0 x 7.9 x 4.2 mm (user supplied)
// World axes: X = width, Y = height (up), Z = depth (front is +Z).

$fn = 48;

// ---------- parameters ----------
clearance      = 0.5;    // per-side fit clearance for housed boards
wall           = 2.4;    // shell wall / back panel / bezel thickness
corner_r       = 10;     // outer corner radius
edge_bevel_back  = 1.5;  // back perimeter chamfer (v3, M6: was 3.0)
edge_bevel_front = 0.8;  // front perimeter chamfer (v3, M6: was 1.6)
grip_rib_step  = 7;      // side grip rib spacing (9 ribs per side)
swell_depth    = 0;      // palm swell REMOVED in v3 (M5); keep code path

badge_w = 84;  badge_h = 76;  badge_d = 21.37;   // Tufty in stock case
pad_w   = 62;  pad_h   = 29;  pad_d   = 8.35;    // Qw/ST Pad in its case
stick_l = 52;  stick_w = 7.9; stick_t = 4.2;     // Multi-Sensor Stick

divider        = 3;      // horizontal webs between zones
badge_lip      = 4.5;    // bezel overlap onto badge face (per side)
pad_lip        = 4.0;    // bezel overlap onto pad case face
boss_hole      = 2.2;    // M2.5 pilot (PLA; use 2.35 for PETG — review m2)
boss_x         = 35.5;   // screw column |x| (top and bottom rows)
pilot_depth    = 10;     // blind pilot hole depth from the front face

// ---------- derived layout ----------
// Zones stack bottom -> top: pad bay, divider, badge bay, divider, stick bay
badge_cav_w = badge_w + 2*clearance;             // 85
badge_cav_h = badge_h + 2*clearance;             // 77
badge_cav_d = badge_d - 1.3;                     // 20.07 (v3, M2)
pad_cav_w   = pad_w + 2*clearance;               // 63
pad_cav_h   = pad_h + 2*clearance + 8;           // 38 (v3, B2: plug room)
pad_cav_d   = pad_d + 0.2;                       // 8.55 (v3, M3)
stick_cav_l = stick_l + 9.5;                     // 61.5 (v3, B2: >= 61)
stick_cav_h = stick_w + 1.6;                     // 9.5 (stick face forward)
stick_cav_d = stick_t + 0.3;                     // 4.5 (v3, M3)

inner_w = badge_cav_w;                                   // 85
inner_h = pad_cav_h + divider + badge_cav_h + divider + stick_cav_h; // 130.5
outer_w = inner_w + 2*wall;                              // 89.8
outer_h = inner_h + 2*wall;                              // 135.3
shell_d = wall + badge_cav_d;                            // 22.47

y0 = wall;                                  // bottom of pad bay
y_pad   = y0;                               // pad bay bottom (2.4)
y_badge = y0 + pad_cav_h + divider;         // badge bay bottom (43.4)
y_stick = y_badge + badge_cav_h + divider;  // stick bay bottom (123.4)

// Screw rows sit in the stick-bay (top) and pad-bay (bottom) margins.
boss_y_top = y_stick + stick_cav_h/2;       // 128.15
boss_y_bot = y_pad + pad_cav_h/2;           // 21.4

// Lanyard lug placement (v3.1): the profile starts at the stick bay's
// top inner face so the lug adds nothing inside the bay.
lug_base_y = y_stick + stick_cav_h;         // 132.9
lug_slot_y = outer_h + 2.6;                 // 137.9, slot centre height

// Badge standoffs (M3): review measured the seated badge-back height
// z 13.57 at badge-relative y 11.1 and 54.1 (v1 frame); rebased here.
standoff_d = 4;
standoff_top_z = 13.57;
standoff_x = 37.5;
standoff_dy = [11.6, 54.6];                 // offsets from y_badge

// Button notch centres (M2), from the buck's modelled caps:
// badge-relative (x, y): bottom row y +6.0, right column x +36.0... 
// (x is absolute/centred; y is relative to the seated badge bottom)
button_notches = [[-18, 6.0], [0, 6.0], [18, 6.0], [36.0, 24.0], [36.0, 42.0]];
notch_size = 8.8;

// Qw/ST divider notches (B2), cut from the front of each divider web.
// Pad connector sits at x ~ +10 on the pad case (from its STL).
pad_notch_x = 10;  pad_notch_w = 16;
stick_notch_w = 54;                          // wide: connector end unknown

// Lanyard lugs (v3.1): two tabs on the top edge of the back shell so
// the unit can be worn as a badge. Shell-side only — no hardware
// measurements needed. Centred at x ±26 so the lug bases sit fully on
// the flat of the top edge, inside the 10 mm corner radii, and clear
// of the top pilot holes at (±35.5, 128.15).
lug_x = 26;  lug_w = 16;  lug_rise = 6;      // rise above the top edge
lug_d = 14;  lug_z0 = 4;                     // depth band (z 4..18)
lug_slot_w = 10;  lug_slot_h = 2.6;          // cord slot, through in Z

// Render selection: 0 assembled (+ghosts), 1 back, 2 bezel, 3 exploded
PART = 0;
EXPLODE = 26;

// ---------- helpers ----------
module rrect_prism(w, h, d, r) {
    translate([0, h/2, 0])
        linear_extrude(height = d)
            offset(r = r) offset(delta = -r)
                square([w, h], center = true);
}
module rrect2(w, h, r) {
    offset(r = r) offset(delta = -r) square([w, h], center = true);
}
// Chamfered slab: full cross-section through the middle, perimeter
// inset by b_back at the back face and b_front at the front face.
module slab(w, h, d, r, b_back, b_front) {
    zs  = [0, b_back, d - b_front, d];
    ins = [b_back, 0, 0, b_front];
    for (i = [0 : len(zs) - 2]) {
        hull() {
            for (j = [i, i + 1]) {
                zp = (j == len(zs) - 1) ? d - 0.2 : zs[j];
                translate([0, h/2, zp])
                    linear_extrude(0.2)
                        rrect2(w - 2*ins[j], h - 2*ins[j], max(1, r - ins[j]));
            }
        }
    }
}
module box_at(x, y, z, sx, sy, sz) {
    translate([x, y, z]) cube([sx, sy, sz], center = true);
}

// ---------- reference ghosts (preview only, never printed) ----------
module badge_ghost() {
    // Badge_Case_Solid_w_Holes.stl: X -42..42 (width), Y -14.77..6.6 (depth,
    // front +6.6), Z -43..33 (height). rotate([90,0,0]) maps STL depth -> +Z
    // (front) and STL height -> Y. The badge sits upright in this ghost
    // (face buttons at the bottom, lanyard tab at the top — review m6).
    translate([0, y_badge + clearance + 33, wall + 0.42 + 14.77])
        rotate([90, 0, 0])
            import("../pimoroni-badgeware-blank/Badge_Case_Solid_w_Holes.stl");
}
module pad_ghost() {
    // Case Front STL: X -2..60, Y -2..27 (height), Z -1..5.75 (depth).
    // Back STL: Z -2.6..2. Offset derived from shell_d / pad_cav_d so the
    // assembled case (8.35 deep) seats on the pad bay floor (review M3).
    gz = shell_d - pad_cav_d + 2.7;
    translate([-29, y_pad + clearance + 2, gz])
        import("../qwst-pad-game-controller-case/QwST Pad Casing Front.stl");
    translate([-29, y_pad + clearance + 2, gz])
        import("../qwst-pad-game-controller-case/QwST Pad Casing Back.stl");
}
module stick_ghost() {
    box_at(0, y_stick + stick_cav_h/2, shell_d - stick_cav_d/2,
           stick_l, stick_w, stick_t);
}

// ---------- back shell ----------
module back_shell() {
    difference() {
        slab(outer_w, outer_h, shell_d, corner_r, edge_bevel_back, edge_bevel_front);
        // badge bay (full depth)
        box_at(0, y_badge + badge_cav_h/2, wall + badge_cav_d/2 + 0.1,
               badge_cav_w, badge_cav_h, badge_cav_d + 0.2);
        // pad bay (shallow, from the front)
        box_at(0, y_pad + pad_cav_h/2, shell_d - pad_cav_d/2 + 0.1,
               pad_cav_w, pad_cav_h, pad_cav_d + 0.2);
        // stick bay (shallow, from the front)
        box_at(0, y_stick + stick_cav_h/2, shell_d - stick_cav_d/2 + 0.1,
               stick_cav_l, stick_cav_h, stick_cav_d + 0.2);
        // Qw/ST cable notches through the divider webs, cut from the
        // front so they actually connect the bays (v3, B2).
        box_at(pad_notch_x, y_badge - divider/2, shell_d - pad_cav_d/2,
               pad_notch_w, divider + 2, pad_cav_d + 0.2);
        box_at(0, y_stick - divider/2, shell_d - stick_cav_d/2,
               stick_notch_w, divider + 2, stick_cav_d + 0.2);
        // M2.5 pilot holes: blind, 10 mm deep from the front face (B1).
        for (sx = [-1, 1], yy = [boss_y_bot, boss_y_top])
            translate([sx * boss_x, yy, shell_d - pilot_depth])
                cylinder(d = boss_hole, h = pilot_depth + 0.1);
    }
    // badge standoffs: the badge back rests on these four posts (M3)
    for (sx = [-1, 1], dy = standoff_dy)
        translate([sx * standoff_x, y_badge + dy, wall])
            cylinder(d = standoff_d, h = standoff_top_z - wall);
    // lanyard lugs (v3.1): rounded tabs rising above the top edge,
    // each with a through slot for a cord or split-ring clip. Unioned
    // after the bay cuts; the profile starts at the stick bay's top
    // inner face, so nothing protrudes into the bay.
    for (sx = [-1, 1])
        difference() {
            translate([sx * lug_x, lug_base_y + (wall + lug_rise)/2, lug_z0])
                linear_extrude(height = lug_d)
                    rrect2(lug_w, wall + lug_rise, 3);
            box_at(sx * lug_x, lug_slot_y, lug_z0 + lug_d/2,
                   lug_slot_w, lug_slot_h, lug_d + 2);
        }
    // gentle palm swell — DISABLED in v3 (M5: forced support over the
    // whole back and rocked on a table). Set swell_depth > 0 to restore.
    if (swell_depth > 0) {
        intersection() {
            translate([0, outer_h * 0.46, 30 - swell_depth])
                scale([60, 80, 30]) sphere(r = 1, $fn = 120);
            translate([0, outer_h/2, -swell_depth/2])
                cube([outer_w, outer_h, swell_depth + 0.2], center = true);
        }
    }
    // grip ribs on both side walls, lower portion (9 per side)
    for (side = [-1, 1], ry = [14 : grip_rib_step : 76])
        translate([side * (outer_w/2 - 0.3), ry, shell_d/2])
            cube([1.8, 3.4, 15], center = true);
}

// ---------- front bezel ----------
module front_bezel() {
    difference() {
        slab(outer_w, outer_h, wall, corner_r, 0.9, 0.9);
        // badge window (lips retain the badge face edges)
        box_at(0, y_badge + badge_cav_h/2, wall/2,
               badge_w - 2*badge_lip + 2*clearance, badge_h - 2*badge_lip + 2*clearance, wall + 2);
        // button notches over the five caps (M2)
        for (n = button_notches)
            box_at(n[0], y_badge + clearance + n[1], wall/2,
                   notch_size, notch_size, wall + 2);
        // pad window (centred on the PAD, not the taller bay — the
        // extra 8 mm of bay height is plug room above the pad, B2)
        box_at(0, y_pad + clearance + pad_h/2, wall/2,
               pad_w - 2*pad_lip + 2*clearance, pad_h - 2*pad_lip + 2*clearance, wall + 2);
        // stick window: one full-length slot (m3)
        box_at(0, y_stick + stick_cav_h/2, wall/2, 52, 5.5, wall + 2);
        // screw clearance holes (M2.5) + counterbore for the head (m1)
        for (sx = [-1, 1], yy = [boss_y_bot, boss_y_top]) {
            translate([sx * boss_x, yy, -1]) cylinder(d = 2.9, h = wall + 3);
            translate([sx * boss_x, yy, wall - 1.2]) cylinder(d = 5.0, h = 1.3);
        }
    }
}

// ---------- assembly ----------
if (PART == 0) {
    color([0.20, 0.62, 0.70]) back_shell();
    translate([0, 0, shell_d]) color([0.95, 0.55, 0.15]) front_bezel();
    %color([0.35, 0.35, 0.38, 0.5]) badge_ghost();
    %color([0.15, 0.30, 0.85, 0.6]) pad_ghost();
    %color([0.10, 0.70, 0.35, 0.7]) stick_ghost();
} else if (PART == 1) {
    back_shell();
} else if (PART == 2) {
    front_bezel();
} else if (PART == 3) {
    color([0.20, 0.62, 0.70]) back_shell();
    translate([0, 0, shell_d + EXPLODE]) color([0.95, 0.55, 0.15]) front_bezel();
    translate([0, 0, EXPLODE * 0.45]) %color([0.35, 0.35, 0.38, 0.5]) badge_ghost();
    translate([0, 0, EXPLODE * 0.45]) %color([0.15, 0.30, 0.85, 0.6]) pad_ghost();
    %color([0.10, 0.70, 0.35, 0.7]) stick_ghost();
}
