// This file models the solid upper cutting block for the single-blade guillotine.

include <BOSL2/std.scad>

include <../params.scad>


module cutting_block(
    base_height=cutting_block_base_height,
    wedge_height=cutting_block_wedge_height,
    tip_radius=cutting_block_tip_radius
) {
    /*
    Solid upper pressure block for cutting with the fixed lower blade.
    The flat back lies at z=0 for printing, with the rounded wedge pointing up.

    Args:
        base_height: float, nominal depth behind the contact edge
        wedge_height: float, height of the wedge below the main block in assembly
        tip_radius: float, radius of the rounded contact edge

    Assembly placement:
        translate([scale_zero_x_position - blade_thickness/2 + cutting_block_front_back_fit_tolerance,
                   width/2, base_height+wall_height])
        rotate([180,0,-90])
            cutting_block();
    */

    back_depth = base_height + cutting_block_front_back_fit_tolerance;
    front_depth = length-slot_length - scale_zero_x_position + blade_thickness/2 -
        cutting_block_front_back_fit_tolerance - cutting_block_width_tolerance;
    block_thickness = back_depth + front_depth;
    front_offset = -front_depth;
    shoulder_height = blade_width - wedge_height;
    // In assembly, this becomes x=scale_zero_x_position+cutting_block_front_back_fit_tolerance.
    tip_y = -blade_thickness/2;

    assert(back_depth > 0 && front_depth > 0,
           "The front and back depths must fit inside the body.");
    assert(wedge_height > 0 && wedge_height < blade_width,
           "The wedge height must be between zero and the blade width.");
    // The rounding may extend into the solid main block; it need not fit inside the wedge height.
    tip_radius_limit = min(tip_y-front_offset, back_depth-tip_y, blade_width/2);
    assert(tip_radius > 0 &&
           (tip_radius < tip_radius_limit || approx(tip_radius, tip_radius_limit)),
           "The tip radius must fit inside the block footprint and above the print bed.");
    // Compensate the spring seat's +0.01 z offset in body.scad.
    // Positive tolerance leaves clearance at the lowest point; negative allows engagement.
    slider_length = cutting_block_slider_length + blade_engagement_tolerance - 0.01;
    assert(slider_length > 0 && slider_length < shoulder_height,
           "The engagement must leave positive slider length below the wedge.");

    union() {
        // Solid main block.
        translate([0, front_offset, 0])
            cuboid(
                size=[blade_slot_length, block_thickness, shoulder_height],
                anchor=FRONT+BOTTOM
            );

        // Wedge with a rounded contact edge above the lower blade.
        hull() {
            translate([0, front_offset, shoulder_height-0.01])
                cuboid(
                    size=[blade_slot_length, block_thickness, 0.01],
                    anchor=FRONT+BOTTOM
                );

            translate([0, tip_y, blade_width-tip_radius])
            rotate([0,90,0])
                cylinder(
                    r=tip_radius,
                    h=blade_slot_length,
                    center=true,
                    $fn=64
                );
        }

        // Two sliders matching the body slots.
        for(x = [-cutting_block_slider_spacing/2, cutting_block_slider_spacing/2]) {
            translate([x, back_depth-0.01, 0])
                cuboid(
                    size=[
                        cutting_block_slider_size,
                        cutting_block_slider_size+0.01,
                        slider_length
                    ],
                    anchor=FRONT+BOTTOM
                );
        }
    }
}


// Flat back on the print bed, rounded wedge facing up.
cutting_block();
