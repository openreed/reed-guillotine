// This file models the blade of the guillotine for oboe and English horn.
// No need to print.

include <BOSL2/std.scad>

include <../params.scad>
use <blade_holder.scad>


module blade() {
    /*
    This module models the blade of the guillotine for oboe and English horn.
    */

    // build the blade
    difference() {
        cuboid(
            size=[blade_length, blade_width, blade_thickness], 
            anchor=BACK
        );

        // blade hole
        translate([0, -hole_edge_distance, 0])
            cylinder(d=hole_diameter, h=blade_thickness+0.01, center=true, $fa=0.5, $fs=0.1);

        // blade side notch
        translate([-blade_length/2-0.01, -side_notch_edge_distance, -blade_thickness/2-0.01])
            side_notch_clamp(
                width=side_notch_width, 
                length=side_notch_length+0.01, 
                height=blade_thickness+0.02
            );
        translate([blade_length/2+0.01, -side_notch_edge_distance, -blade_thickness/2-0.01])
        rotate([0, 0, 180]) 
            side_notch_clamp(
                width=side_notch_width, 
                length=side_notch_length+0.01, 
                height=blade_thickness+0.02
            );
    }

    // back clamp
    translate([0, -(blade_width-back_clamp_width), 0])
        cuboid(
            size=[blade_length, back_clamp_width, back_clamp_thickness+blade_thickness], 
            anchor=BACK,
        );

}

blade();