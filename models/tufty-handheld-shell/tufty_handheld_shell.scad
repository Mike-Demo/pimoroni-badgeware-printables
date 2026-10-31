// Tufty 2350 handheld — FULL SHELL case (v2: ergonomics pass)
// v2 changes: corner radius 6 -> 10 mm, chamfered front/back perimeter
// edges (3 mm back / 1.6 mm front), a gentle palm swell on the back,
// and grip ribs on both side walls. Internal bays, clips, bosses and
// windows are unchanged from v1, so fit behaviour is identical.
// =====================================================================
// A complete two-part shell that houses all three boards at once:
//   * Tufty 2350 (in its stock polycarbonate case) — clips into the
//     badge bay on internal spring clips; the front bezel also retains it
//   * Qw/ST Pad (in Pimoroni's printable case) — sits in the lower bay
//     behind its own bezel window, D-pads / buttons facing forward
//   * Multi-Sensor Stick — slides into the top bay, sensor face forward
//     behind a bezel window, with vent slots for the BME280
// Parts: back_shell (PART=1) and front_bezel (PART=2), joined by
// 4x M2.5 screws into bosses in the back shell's top/bottom margins.
//
// Reference dimensions (measured 2026-10-31 from Pimoroni's own STLs
// in github.com/Mike-Demo/pimoroni-badgeware-printables):
//   Badgeware badge-in-case solid : 84.0 x 76.0 x 21.37 mm
//   Qw/ST Pad case (assembled)    : 62.0 x 29.0 x ~8.35 mm
//   Multi-Sensor Stick            : 52.0 x 7.9 x 4.2 mm (user supplied)
//
// FIT-CHECK BEFORE PRINTING (see README.md): screen/button layout of
// the real Tufty vs the badge window, USB-C port position, Qw/ST cable
// routing between pad / sensor / badge, sensor window alignment.
// World axes: X = width, Y = height (up), Z = depth (front is +Z).

$fn = 48;

// ---------- parameters ----------
clearance      = 0.5;    // per-side fit clearance for housed boards
wall           = 2.4;    // shell wall / back panel / bezel thickness
corner_r       = 10;     // outer corner radius (v2: was 6)
edge_bevel_back  = 3.0;  // back perimeter chamfer (v2)
edge_bevel_front = 1.6;  // front perimeter chamfer (v2)
grip_rib_step  = 7;      // side grip rib spacing (v2)
swell_rx = 60; swell_ry = 80; swell_rz = 30;  // palm swell radii (v2)
swell_depth    = 2.2;    // how proud the palm swell sits (v2)

badge_w = 84;  badge_h = 76;  badge_d = 21.37;   // Tufty in stock case
pad_w   = 62;  pad_h   = 29;  pad_d   = 8.35;    // Qw/ST Pad in its case
stick_l = 52;  stick_w = 7.9; stick_t = 4.2;     // Multi-Sensor Stick

divider        = 3;      // horizontal webs between zones
badge_lip      = 4.5;    // bezel overlap onto badge face (per side)
pad_lip        = 4.0;    // bezel overlap onto pad case face
clip_proud     = 1.1;    // how far badge spring clips protrude
clip_h         = 9;      // badge spring clip height
boss_od        = 6.5;    // bezel screw boss outer diameter
boss_hole      = 2.2;    // M2.5 pilot hole

// ---------- derived layout ----------
// Zones stack bottom -> top: pad bay, divider, badge bay, divider, stick bay
badge_cav_w = badge_w + 2*clearance;             // 85
badge_cav_h = badge_h + 2*clearance;             // 77
badge_cav_d = badge_d + 0.83;                    // 22.2 from front opening
pad_cav_w   = pad_w + 2*clearance;               // 63
pad_cav_h   = pad_h + 2*clearance;               // 30
pad_cav_d   = pad_d + 1.05;                      // 9.4 from front opening
stick_cav_l = stick_l + 1.5;                     // 53.5
stick_cav_h = stick_w + 1.6;                     // 9.5 (stick face forward)
stick_cav_d = stick_t + 1.4;                     // 5.6 from front opening

inner_w = badge_cav_w;                                   // 85
inner_h = pad_cav_h + divider + badge_cav_h + divider + stick_cav_h; // 122.5
outer_w = inner_w + 2*wall;                              // 89.8
outer_h = inner_h + 2*wall;                              // 127.3
shell_d = wall + badge_cav_d;                            // 24.6 (back shell depth)

y0 = wall;                                  // bottom of pad bay
y_pad   = y0;                               // pad bay bottom
y_badge = y0 + pad_cav_h + divider;         // badge bay bottom (35.4)
y_stick = y_badge + badge_cav_h + divider;  // stick bay bottom (115.4)

// Screw boss centres: top corners sit in the stick-bay side margins,
// bottom corners in the pad-bay side margins.
boss_x_top = inner_w/2 - 7;
boss_x_bot = inner_w/2 - 7;
boss_y_top = y_stick + stick_cav_h/2;
boss_y_bot = y_pad + pad_cav_h/2;

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
// inset by b_back at the back face and b_front at the front face (v2).
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
    // (front) and STL height -> Y (badge sits upside-down in the ghost only;
    // the blank is near-symmetric — the shell itself is unaffected).
    translate([0, y_badge + clearance + 33, wall + 0.42 + 14.77])
        rotate([90, 0, 0])
            import("../pimoroni-badgeware-blank/Badge_Case_Solid_w_Holes.stl");
}
module pad_ghost() {
    // Case Front STL: X -2..60, Y -2..27 (height), Z -1..5.75 (depth, front +).
    // Back STL: Z -2.6..2. Placed so the assembled case fills the pad bay.
    // Both pieces share z offset 18.44: front face at 24.19, assembled
    // depth 8.35 (pieces telescoped), back face at 15.84 inside the bay.
    translate([-29, y_pad + clearance + 2, 18.44])
        import("../qwst-pad-game-controller-case/QwST Pad Casing Front.stl");
    translate([-29, y_pad + clearance + 2, 18.44])
        import("../qwst-pad-game-controller-case/QwST Pad Casing Back.stl");
}
module stick_ghost() {
    box_at(0, y_stick + stick_cav_h/2, shell_d - stick_cav_d/2 - 0.0,
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
        // Qw/ST cable pass-throughs in the divider webs (rear side):
        // pad bay <-> badge bay, and stick bay <-> badge bay.
        box_at(20, y_badge - divider/2, wall + 3.5, 16, divider + 2, 7);
        box_at(-18, y_stick - divider/2, wall + 3, 10, divider + 2, 6);
        // USB-C candidate cutout, bottom wall centre — VERIFY POSITION
        box_at(0, 1.2, shell_d/2, 12, wall + 2, 5);
    }
    // badge spring clips: 2 per side inside the badge bay, near the front,
    // so the badge presses in past them and snaps into place.
    for (side = [-1, 1], fy = [0.3, 0.7]) {
        translate([side * (badge_cav_w/2 - clip_proud/2 + 0.2),
                   y_badge + badge_cav_h * fy,
                   shell_d - 4.5])
            cube([clip_proud + 0.4, clip_h, 5], center = true);
    }
    // (the badge rests on the divider web at the bottom of its bay)
    // bezel screw bosses in the top / bottom margins
    for (sx = [-1, 1]) {
        translate([sx * boss_x_top, boss_y_top, 0])
            difference() {
                cylinder(d = boss_od, h = shell_d);
                cylinder(d = boss_hole, h = shell_d + 1);
            }
        translate([sx * boss_x_bot, boss_y_bot, 0])
            difference() {
                cylinder(d = boss_od, h = shell_d);
                cylinder(d = boss_hole, h = shell_d + 1);
            }
    }
    // gentle palm swell on the back: clipped ellipsoid cap (v2)
    intersection() {
        translate([0, outer_h * 0.46, swell_rz - swell_depth])
            scale([swell_rx, swell_ry, swell_rz]) sphere(r = 1, $fn = 120);
        translate([0, outer_h/2, -swell_depth/2])
            cube([outer_w, outer_h, swell_depth + 0.2], center = true);
    }
    // grip ribs on both side walls, lower two-thirds (v2)
    for (side = [-1, 1], ry = [14 : grip_rib_step : 76])
        translate([side * (outer_w/2 - 0.3), ry, shell_d/2])
            cube([1.8, 3.4, 15], center = true);
}

// ---------- front bezel ----------
module front_bezel() {
    difference() {
        union() {
            slab(outer_w, outer_h, wall, corner_r, 0.9, 0.9);
        }
        // badge window (lips retain the badge face edges)
        box_at(0, y_badge + badge_cav_h/2, wall/2,
               badge_w - 2*badge_lip + 2*clearance, badge_h - 2*badge_lip + 2*clearance, wall + 2);
        // pad window
        box_at(0, y_pad + pad_cav_h/2, wall/2,
               pad_w - 2*pad_lip + 2*clearance, pad_h - 2*pad_lip + 2*clearance, wall + 2);
        // stick window (sensor face) + two vent slots for the BME280 end
        box_at(0, y_stick + stick_cav_h/2, wall/2, 44, 5.5, wall + 2);
        for (vx = [-22, 22])
            box_at(vx, y_stick + stick_cav_h/2, wall/2, 7, 2.2, wall + 2);
        // screw clearance holes (M2.5)
        for (sx = [-1, 1]) {
            translate([sx * boss_x_top, boss_y_top, -1]) cylinder(d = 2.9, h = wall + 3);
            translate([sx * boss_x_bot, boss_y_bot, -1]) cylinder(d = 2.9, h = wall + 3);
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
