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
                anchor=LEFT+BOTTOM
            );

            cuboid(
                size=[reed_holder_length, reed_holder_width, scale_zero_z_position-base_height],  // height of the reed should be consistent with height of the blade
                anchor=LEFT+BOTTOM,
            );
        }


    }
    
}


reed_holder();