// This file models the handle part of the guillotine, including the handle and the axle.
include <BOSL2/std.scad>

include <../params.scad>

module axle() {
    /*
    This module models the axle for the handle.
    */

    cyl(
        d=handle_axis_diameter, 
        h=handle_axis_length, 
        anchor=BOTTOM, 
        $fa=0.5, 
        $fs=0.1,
        chamfer=handle_axis_chamfer,
    );
}


module handle() {
    /*
    This module models the handle of the guillotine.

    General structure of the handle:
    +---------------------------------------+
    |                                       |
    |        +------------------------------+
    | +----+ |
    | |    | |
    | +----+ |
    +--------+

    */
    
    difference() {
        union() {
            // grip
        }
        
    }

}



translate([-30,0,0])
axle();

translate([30,0,0])
handle();
