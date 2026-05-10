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

            translate([staple_slot_length, 0, slot_height])
                cuboid(
                    size=[
                        reed_holder_length - staple_slot_length,
                        reed_holder_width, 
                        reed_holder_height - slot_height
                    ],
                    anchor=LEFT+BOTTOM,
                    rounding=reed_holder_fillet,
                    $fa=0.5,
                    $fs=0.1,
                );
        }

        // fillet
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
        translate([0, staple_slot_diameter/2, scale_zero_z_position-base_height])
        rotate([-10,0,0])
            rounding_edge_mask(
                l=staple_slot_length,
                r=reed_holder_fillet,
                ang=100,
                anchor=BOTTOM,
                orient=RIGHT,
                $fa=0.5,
                $fs=0.1,
            );
        translate([0, -staple_slot_diameter/2, scale_zero_z_position-base_height])
        rotate([-90,0,0])
            rounding_edge_mask(
                l=staple_slot_length,
                r=reed_holder_fillet,
                ang=100,
                anchor=BOTTOM,
                orient=RIGHT,
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

        // screw
        translate([reed_holder_screw_x_position,0,reed_holder_height])
            screw_hole(
                format("{},{:.2f}", [reed_holder_screw_type, reed_holder_height+0.01]),
                anchor=TOP, 
                thread=true,
                tolerance="8G",
                $fa=0.5,
                $fs=0.1
            );
        
        // mandrel slot
        difference() {
            union() {
                translate([reed_holder_length+0.01, 0, reed_holder_height+0.01])
                    cuboid(
                        size=[mandrel_slot_depth+0.01, mandrel_slot_diameter, reed_holder_height-scale_zero_z_position+base_height+0.01],
                        anchor=TOP+RIGHT,
                        rounding=-reed_holder_fillet,
                        edges=[TOP],
                        $fa=0.5,
                        $fs=0.1,
                    );
                translate([reed_holder_length+0.01, 0, scale_zero_z_position-base_height]) 
                    cyl(
                        h=mandrel_slot_depth+0.01,
                        d=mandrel_slot_diameter,
                        orient=LEFT,
                        anchor=BOTTOM,
                        rounding1=-reed_holder_fillet,
                        $fa=0.5,
                        $fs=0.1,
                    );
                // edge fillet
                translate([reed_holder_length+0.01, -mandrel_slot_diameter/2, scale_zero_z_position-base_height]) 
                rotate([0,0,180])
                    rounding_edge_mask(
                        l=reed_holder_height+0.01,
                        r=reed_holder_fillet,
                        ang=90,
                        orient=UP,
                        anchor=BOTTOM,
                        $fa=0.5,
                        $fs=0.1,
                    );
                translate([reed_holder_length+0.01, mandrel_slot_diameter/2, scale_zero_z_position-base_height])
                rotate([0,0,90])
                    rounding_edge_mask(
                        l=reed_holder_height+0.01,
                        r=reed_holder_fillet,
                        ang=90,
                        orient=UP,
                        anchor=BOTTOM,
                        $fa=0.5,
                        $fs=0.1,
                    );
            }
            translate([reed_holder_length-mandrel_slot_depth, 0, scale_zero_z_position-base_height])
                cyl(
                    h=mandrel_slot_depth+0.01,
                    d=mandrel_diameter,
                    orient=RIGHT,
                    anchor=BOTTOM,
                    rounding2=reed_holder_fillet,
                    $fa=0.5,
                    $fs=0.1,
                );
        }
    }
}


module tightening_screw() {
    spec = screw_info(
        format("{},{:.2f}", [reed_holder_screw_type, tightening_screw_height]), 
        head="socket"
    );
    newspec = struct_set(
        spec,
        [
            "head_size",tightening_screw_head_diameter,
            "head_height",tightening_screw_head_height
        ]
    );
    screw(newspec, anchor=TOP, orient=DOWN, $fa=0.5, $fs=0.1);
}




reed_holder();

translate([-20,0,0])
    tightening_screw();
