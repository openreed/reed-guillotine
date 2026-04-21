include <BOSL2/std.scad>

include <../params.scad>

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


module bottom_blade_holder(height) {
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
        back_clamp_chamfer = (back_clamp_thickness+back_clamp_thickness_tolerance) * sqrt(2);
        translate([0, back_clamp_width+back_clamp_width_tolerance, height-back_clamp_thickness-back_clamp_thickness_tolerance])
        rotate([45,0,0])
            cuboid(
                size=[blade_length+0.01, back_clamp_chamfer+0.01, back_clamp_chamfer+0.01], 
                anchor=FRONT+BOTTOM
            );
        
        // side notches
        translate([-blade_length/2-0.01, blade_width-side_notch_edge_distance, -0.01])
        side_notch_clamp(
            width=side_notch_width - side_notch_tolerance, 
            length=side_notch_length - side_notch_tolerance + 0.01, 
            height=height+0.02
        );
    
        translate([blade_length/2+0.01, blade_width-side_notch_edge_distance, -0.01])
        rotate([0,0,180])
            side_notch_clamp(
                width=side_notch_width - side_notch_tolerance, 
                length=side_notch_length - side_notch_tolerance + 0.01, 
                height=height+0.02
            );
    }

    

}


module blade_clamp(height) {
    difference() {
        // basic cuboid
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

    // side notches
    translate([-blade_length/2 - 0.01, blade_width-side_notch_edge_distance, height-0.01])
        side_notch_clamp(
            width=side_notch_width - side_notch_tolerance, 
            length=side_notch_length - side_notch_tolerance, 
            height=side_notch_height+0.02
        );
        
    translate([blade_length/2 + 0.01, blade_width-side_notch_edge_distance, height-0.01])
    rotate([0,0,180])
        side_notch_clamp(
            width=side_notch_width + side_notch_tolerance, 
            length=side_notch_length + side_notch_tolerance + 0.01, 
            height=side_notch_height+0.02
        );
}


module upper_blade_holder(base_height, ){
    translate([0, blade_width-blade_protrusion_length, base_height])
    rotate([0,180,180])
        bottom_blade_holder(height=base_height);
    
    // two sliders on the upper blade holder
    translate([-upper_blade_holder_slider_spacing/2, blade_width-blade_protrusion_length, base_height])
        cuboid(
            size=[upper_blade_holder_slider_size, upper_blade_holder_slider_length, upper_blade_holder_slider_size],
            anchor=BACK+BOTTOM
        );
    translate([upper_blade_holder_slider_spacing/2, blade_width-blade_protrusion_length, base_height])
        cuboid(
            size=[upper_blade_holder_slider_size, upper_blade_holder_slider_length, upper_blade_holder_slider_size],
            anchor=BACK+BOTTOM
         );

}


translate([-30,-20,0]) 
    bottom_blade_holder(height=cutting_block_length);

translate([-30, 0, 0]) 
    blade_clamp(height=blade_clamp_height);

translate([30, 0, 0])
upper_blade_holder(base_height = upper_blade_holder_base_height);
