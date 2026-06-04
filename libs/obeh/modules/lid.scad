// This file models the lid of the guillotine, which is used to cover the top of the wall of the body.

include <BOSL2/std.scad>
include <BOSL2/screws.scad>

include <../params.scad>


module lid() {
    /*
    This module models the lid of the guillotine, which is used to cover the top of the wall of the body.
    */
    difference() {
        // lid body
        union() {
            // left body
            translate([length-slot_length+wall_skirt_thickness, 0, 0])
                cuboid(
                    size=[wall_total_length, wall_thickness, lid_height], 
                    anchor=BOTTOM+RIGHT+FRONT, 
                    chamfer=lid_chamfer,
                    edges=TOP,
                );
            // right body
            translate([length-slot_length+wall_skirt_thickness, width, 0])
                cuboid(
                    size=[wall_total_length, wall_thickness, lid_height], 
                    anchor=BOTTOM+RIGHT+BACK,
                    chamfer=lid_chamfer,
                    edges=TOP,
                );
            // back body
            if(lid_back_thickness != 0){
                translate([length-slot_length+wall_skirt_thickness - wall_total_length, width/2, 0])
                    cuboid(
                        size=[lid_back_thickness, width, lid_height], 
                        anchor=BOTTOM+LEFT,
                        chamfer=lid_chamfer,
                        edges=TOP,
                    );
            }
                
        }

        // screw holes
        for(i = [0:len(wall_screw_x_positions)-1]){
            translate([wall_screw_x_positions[i], wall_screw_center_side_distance, lid_height+0.01])
                union() {
                    cylinder(
                        d=lid_screw_slot_head_diameter, 
                        h=lid_screw_slot_head_depth+0.01, 
                        anchor=TOP, 
                        $fa=0.5, 
                        $fs=0.1
                    );
                    cylinder(
                        d=lid_screw_slot_diameter, 
                        h=lid_height+0.02, 
                        anchor=TOP, 
                        $fa=0.5, 
                        $fs=0.1
                    );
                }
                
            translate([wall_screw_x_positions[i], width - wall_screw_center_side_distance, lid_height+0.01])
                union() {
                    cylinder(
                        d=lid_screw_slot_head_diameter, 
                        h=lid_screw_slot_head_depth+0.01, 
                        anchor=TOP, 
                        $fa=0.5, 
                        $fs=0.1
                    );
                    cylinder(
                        d=lid_screw_slot_diameter, 
                        h=lid_height+0.02, 
                        anchor=TOP, 
                        $fa=0.5, 
                        $fs=0.1
                    );
                }
        }

        // grooves for wall tongues
        for(x = wall_tongue_x_positions) {
            translate([x, wall_tongue_center_back_distance, -0.01])
                cylinder(
                    d=wall_tongue_diameter + lid_groove_diameter_tolerance, 
                    h=wall_tongue_height + lid_groove_height_tolerance + 0.01, 
                    anchor=BOTTOM, 
                    $fa=0.5, 
                    $fs=0.1
                );
            translate([x, width - wall_tongue_center_back_distance, -0.01])
                cylinder(
                    d=wall_tongue_diameter + lid_groove_diameter_tolerance, 
                    h=wall_tongue_height + lid_groove_height_tolerance + 0.01, 
                    anchor=BOTTOM, 
                    $fa=0.5, 
                    $fs=0.1,
                );
        }

    }
    
    


}

lid();