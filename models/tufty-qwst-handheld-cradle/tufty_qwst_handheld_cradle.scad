// First-fit shared carrier for the Tufty 2350, Qw/ST Pad, and sensor stick.
// Dimensions are millimetres. This is a fit-test design, not a production-ready case.

$fn = 32;

// Badgeware blank bounds measured from Pimoroni's supplied STL:
// X = 84 mm, Z = 76 mm, original Y (depth) = 21.37 mm.
badge_width = 84;
badge_height = 76;

// Pimoroni Qw/ST Pad case mesh bounds: 62 x 29 x 8.35 mm.
pad_case_width = 62;
pad_case_height = 29;
pad_case_depth = 8.35;
pad_clearance = 0.5;

// Set to 1 to show the official Badgeware case and Qw/ST Pad case meshes.
show_reference_models = 0;

// World axes: X = badge width, Y = vertical, Z = front/back.
badge_front_z = -6.6;
badge_back_z = 14.77;
frame_back_z = badge_back_z + 1.2;
frame_thickness = 3;
frame_rail_width = 4;
badge_clip_y = [-29, 24];
badge_clip_height = 8;
badge_clip_wall = 1.6;
badge_clip_lip = 1.7;

pad_center_y = -61.5;
pad_back_z = 1.75;
pad_rail_width = 2.5;
pad_lip = 1.5;
pad_clip_height = 5;

module badge_reference() {
    // Source STL axes are X=width, Y=depth, Z=height.
    // Rotate so the badge's height is world Y and its front points toward -Z.
    rotate([-90, 0, 0])
        translate([0, 0, 5])
            import("../pimoroni-badgeware-blank/Badge_Case_Solid_w_Holes.stl");
}

module pad_reference() {
    // Reflect the official case so the button face points toward the badge front.
    translate([-29, pad_center_y - 12.5, pad_back_z - 2.6])
        mirror([0, 0, 1])
            import("../qwst-pad-game-controller-case/QwST Pad Casing Front.stl");
    translate([-29, pad_center_y - 12.5, pad_back_z - 2.6])
        mirror([0, 0, 1])
            import("../qwst-pad-game-controller-case/QwST Pad Casing Back.stl");
}

module rear_frame() {
    // Open back frame keeps the Tufty's rear controls and connectors accessible.
    for (side = [-1, 1]) {
        translate([side * (badge_width / 2 + 2.8), -4, frame_back_z])
            cube([frame_rail_width, badge_height - 8, frame_thickness], center=true);
    }
    translate([0, -badge_height / 2 + 1, frame_back_z])
        cube([badge_width + 2 * frame_rail_width, frame_rail_width, frame_thickness], center=true);
}

module badge_edge_clips() {
    for (side = [-1, 1], clip_y = badge_clip_y) {
        // Flexible side spring and a short front-facing retaining toe.
        translate([side * (badge_width / 2 + 1.2), clip_y, (badge_front_z + frame_back_z) / 2])
            cube([badge_clip_wall, badge_clip_height, frame_back_z - badge_front_z], center=true);
        translate([side * (badge_width / 2 - badge_clip_lip / 2 + 0.2),
                   clip_y,
                   badge_front_z + 0.6])
            cube([badge_clip_lip + 0.5, badge_clip_height, 1.2], center=true);
    }
}

module pad_supports() {
    // Two struts bridge the depth offset between the badge rails and the pad cradle.
    for (side = [-1, 1]) {
        hull() {
            translate([side * 42.2, -badge_height / 2 - 1, frame_back_z])
                cube([5, 3, frame_thickness], center=true);
            translate([side * 34, pad_center_y + pad_case_height / 2, pad_back_z])
                cube([5, 3, frame_thickness], center=true);
        }
    }
}

module pad_holder() {
    holder_width = pad_case_width + 2 * pad_clearance;
    holder_height = pad_case_height + 2 * pad_clearance;
    z_rear = pad_back_z + frame_thickness / 2;
    z_front = pad_back_z - pad_case_depth - pad_lip;
    stop_width = 17;
    stop_x = holder_width / 2 + pad_rail_width / 2 - stop_width / 2;

    // Side rails and lower seat retain the official case while leaving its face open.
    for (side = [-1, 1]) {
        translate([side * (holder_width / 2 + pad_rail_width / 2),
                   pad_center_y,
                   (z_rear + z_front) / 2])
            cube([pad_rail_width, holder_height, z_rear - z_front], center=true);
    }
    translate([0, pad_center_y - holder_height / 2 - pad_rail_width / 2 + 0.5,
               (z_rear + z_front) / 2])
        cube([holder_width + 2 * pad_rail_width, pad_rail_width, z_rear - z_front], center=true);

    // Two end stops retain the case while leaving the central Qw/ST sockets open.
    for (side = [-1, 1]) {
        translate([side * stop_x,
                   pad_center_y + holder_height / 2 + pad_rail_width / 2 - 0.5,
                   (z_rear + z_front) / 2])
            cube([stop_width, pad_rail_width, z_rear - z_front], center=true);
    }

    // Small retaining toes overlap only the outside edge of the pad case.
    for (side = [-1, 1]) {
        translate([side * (holder_width / 2 + pad_rail_width / 2 - 0.2),
                   pad_center_y,
                   z_front + 0.6])
            cube([pad_lip + pad_rail_width - 0.4, pad_clip_height, 1.2], center=true);
    }
}

module cradle() {
    union() {
        rear_frame();
        badge_edge_clips();
        pad_supports();
        pad_holder();
    }
}

if (show_reference_models) {
    %color([0.95, 0.45, 0.05, 0.35]) badge_reference();
    %color([0.1, 0.3, 0.8, 0.55]) pad_reference();
}

color([0.2, 0.65, 0.75]) cradle();
