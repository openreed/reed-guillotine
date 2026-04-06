include <BOSL2/std.scad>

module side_notch_clamp(
    width=2.5, length=3.5, height=1.5
) {
    /*
    This module models the side notch clamp of the blade holder, which is used to clamp the blade from the side. 
    Args:
        width: float, width of the side notch clamp
        length: float, length of the side notch clamp
        height: float, height of the side notch clamp
    
        ----+-------------------++
          ^ |                      --+
          | |                        -+
    width | |                         -+
          | |                        -+
          v |                      --+
        ----+-------------------++
            |<------------------------>|
                    length
    */
    union() {
        cuboid(
            size=[length-width/2, width, height], 
            anchor=BOTTOM+LEFT,
        );
        translate([length-width/2, 0, 0])
            cylinder(h = height, r = width/2, anchor=BOTTOM, $fa=0.5, $fs=0.1);
    }
}


module test_blader_holder(
    // blade parameters
    blade_length=39, blade_width=19, 
    hole_diameter=2, hole_edge_distance=7,
    side_notch_width=2.5, side_notch_length=3.5, side_notch_edge_distance=9.6,
    back_clamp_thickness=0.2, back_clamp_width=7,

    // blade holder parameters
    blade_protrusion_length=2, height=4,
    side_notch_height=1.5, side_notch_tolerance=0.1,
    back_clamp_thickness_tolerance=0.5, back_clamp_width_tolerance=0.2,
    is_clamp=false
) {
    difference() {
        // body
        cuboid(
            size=[blade_length, blade_width-blade_protrusion_length, height], 
            anchor=BOTTOM+FRONT,
        );

        // blade hole
        translate([0, blade_width-hole_edge_distance, -0.01])
            cylinder(d=hole_diameter, h=height+0.02, anchor=BOTTOM, $fa=0.5, $fs=0.1);

        // blade back clamp
        translate([0, -0.01, height-back_clamp_thickness-back_clamp_thickness_tolerance])
            cuboid(
                size=[blade_length+0.01, back_clamp_width+back_clamp_width_tolerance+0.01, back_clamp_thickness+back_clamp_thickness_tolerance+0.01], 
                anchor=FRONT+BOTTOM
            );
    }

    translate([-blade_length/2, blade_width-side_notch_edge_distance, height-0.01])
        side_notch_clamp(
            width=side_notch_width - side_notch_tolerance, 
            length=side_notch_length - side_notch_tolerance, 
            height=side_notch_height+0.01
        );
    
    translate([blade_length/2, blade_width-side_notch_edge_distance, height-0.01])
    rotate([0,0,180])
        side_notch_clamp(
            width=side_notch_width - side_notch_tolerance, 
            length=side_notch_length - side_notch_tolerance, 
            height=side_notch_height+0.01
        );
    

}


module test_blade_clamp(
    // blade parameters
    blade_length=39, blade_width=19, 
    hole_diameter=2, hole_edge_distance=7,
    side_notch_width=2.5, side_notch_length=3.5, side_notch_edge_distance=9.6,
    back_clamp_thickness=0.2, back_clamp_width=7,

    // blade clamp parameters
    blade_protrusion_length=2, height=3,
    side_notch_tolerance=0.1,
    back_clamp_thickness_tolerance=0.5, back_clamp_width_tolerance=0.2,
) {
    difference() {
        // basic cuboid
        cuboid(
            size=[blade_length, blade_width-blade_protrusion_length, height], 
            anchor=BOTTOM+FRONT,
        );

        // blade hole
        translate([0, blade_width-hole_edge_distance, -0.01])
            cylinder(d=hole_diameter, h=height+0.02, anchor=BOTTOM, $fa=0.5, $fs=0.1);

        // side notches
        translate([-blade_length/2 - 0.01, blade_width-side_notch_edge_distance, -0.01])
            side_notch_clamp(
                width=side_notch_width - side_notch_tolerance, 
                length=side_notch_length - side_notch_tolerance, 
                height=height+0.02
            );
        
        translate([blade_length/2 + 0.01, blade_width-side_notch_edge_distance, -0.01])
        rotate([0,0,180])
            side_notch_clamp(
                width=side_notch_width + side_notch_tolerance, 
                length=side_notch_length + side_notch_tolerance + 0.01, 
                height=height+0.02
            );
        
        // blade back clamp
        translate([0, -0.01, height-back_clamp_thickness-back_clamp_thickness_tolerance])
            cuboid(
                size=[blade_length+0.01, back_clamp_width+back_clamp_width_tolerance+0.01, back_clamp_thickness+back_clamp_thickness_tolerance+0.01], 
                anchor=FRONT+BOTTOM
            );
        
    }
}


test_blader_holder();

translate([0, -20, 0]) 
    test_blade_clamp();