// This file models the reed holder and the tightening screw for the guillotine

include <BOSL2/std.scad>
include <BOSL2/screws.scad>

include <../params.scad>


module reed_holder() {
    /*
    Body of the reed holder.
    */

    difference() {
        union() {
            prismoid(
                size2=[reed_holder_length, reed_holder_width], 
                h=slot_height, 
                xang=[90,90], 
                yang=[slot_bottom_angle,slot_bottom_angle], 
                anchor=LEFT+BOTTOM,
                rounding=reed_holder_fillet,
                $fa=0.5,
                $fs=0.1,
            );

            cuboid(
                size=[reed_holder_length, reed_holder_width, scale_zero_z_position-base_height],  // height of the reed should be consistent with height of the blade
                anchor=LEFT+BOTTOM,
                rounding=reed_holder_fillet,
                $fa=0.5,
                $fs=0.1,

            );
        }

        // rounding
        translate([reed_holder_length/2, -(reed_holder_width/2 + slot_height/tan(slot_bottom_angle)), 0])
        rotate([90,0,0])
            rounding_edge_mask(
                l=reed_holder_length+0.01,
                r=reed_holder_fillet,
                ang=slot_bottom_angle,
                orient=RIGHT,
                $fa=0.5,
                $fs=0.1,
            );
        translate([reed_holder_length/2, +(reed_holder_width/2 + slot_height/tan(slot_bottom_angle)), 0])
        rotate([90,0,0])
            rounding_edge_mask(
                l=reed_holder_length+0.01,
                r=reed_holder_fillet,
                ang=slot_bottom_angle,
                orient=LEFT,
                $fa=0.5,
                $fs=0.1,
            );
        
        // staple slot
        translate([staple_slot_length, 0, scale_zero_z_position-base_height])
            cyl(
                h = staple_slot_length+0.01, 
                r = staple_slot_diameter/2, 
                anchor=BOTTOM, 
                orient=LEFT, 
                rounding2=-reed_holder_fillet,
                $fa=0.5, $fs=0.1
            );
        


    }
    
}


reed_holder();