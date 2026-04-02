// This file models the main body of the guillotine for oboe and English horn.

include <BOSL2/std.scad>

use <../../utils/utils.scad>


module scale(length, width, height, 
             content, content_bar_distance=5, font_size=2) {
    /*
    This module models the scale scale of the guillotine.
          +-------------------+
    width |(origin)           | {content}
          +-------------------+
                 length
    
    Args:
        length: float, length of the scale bar
        width: float, width of the scale bar
        height: float, height of the scale bar
        content: string or boolean, text content on the scale bar, if set to false, no text will be generated
        content_bar_distance: float, distance between the scale bar and the text content
        font_size: float, font size of the text content, approximately equals to the height of the text content, refer to BOSL2 documentation for more details
    */
    union() {
        // Scale bar
        cube([length, width, height], anchor=LEFT+BOTTOM);
        
        // Text content
        if(content){
            translate([length + content_bar_distance, 0, 0])
                text3d(content, h=height, size=font_size, anchor=LEFT+BOTTOM, atype="ycenter");
        }
        
    }
}


module build_body(
    // base parameters
    length=132, width=46, base_height=10, base_corner_fillet=10, base_edge_chamfer=1,
    // slot parameters
    slot_top_width=16, slot_bottom_angle=72, slot_length=92, slot_height=4, slot_top_corner_fillet=0.4,
    // scale parameters
    scale_zero_x_position=37, scale_tolerance=0.3, scale_range=[30,80],
    scale_bar_major_length=6, scale_bar_submajor_length=5.2, scale_bar_minor_length=4.6, scale_bar_minor_length_diff=0.35,
    scale_bar_width=0.4, scale_bar_height=0.4,
    scale_font_distance=0.6, scale_font_size=4,
    // blade stand parameters
    stand_length=30, stand_height=25, 

    // handle parameters
    handle_axis_x_position=21, handle_axis_z_position=29, handle_axis_diameter=9, handle_axis_hole_tolerance=0.1,

    // blade holder parameters

    // lid parameters

    

) {
    /*
    This module models the base of the guillotine for oboe and English horn.

    Args:
        Base parameters:
            length: float, length of the base
            width: float, width of the base
            base_height: float, height of the base
            base_corner_fillet: float, fillet radius of the corners of the base
            base_edge_chamfer: float, chamfer distance of the edges of the base
        Slot parameters:
            slot_top_width: float, width of the top of the slot for the reed holder
            slot_bottom_angle: float, angle between the bottom and the side of the slot for the reed holder, in degree
            slot_length: float, length of the slot for the reed holder
            slot_height: float, height of the slot for the reed holder
            slot_top_corner_fillet: float, fillet radius of the two top edges of the slot for the reed holder
        Scale parameters:
            scale_zero_x_position: float, x position of the zero point of the scale, i.e., the coordinate of the blade
            scale_tolerance: float, tolerance of the scale, positive values will make the scale bars longer, while negative values will make the scale bars shorter
            scale_range: list of two integers, the minimum and maximum values on the scale
            scale_bar_major_length: float, length of the scale bars for those scale values that are multiples of 10, i.e., 30, 40, 50
            scale_bar_submajor_length: float, length of the scale bars for those scale values that are multiples of 5 but not multiples of 10, i.e., 35, 45, 55
            scale_bar_minor_length: float, length of the scale bars for those scale values satisfying {value - 1 mod 5 == 0}, i.e., 31, 36, 41, 46, 51
            scale_bar_minor_length_diff: float, lengths of the other scale bars equal to {scale_bar_minor_length - scale_bar_minor_length_diff * x}, 
                where x = |value - minor_value|, where minor_value is the closest value that satisfies {(value - 1) mod 5 == 0} and larger than value. 
            scale_bar_width: float, width of the scale bars
            scale_bar_height: float, height of the scale bars
            scale_font_distance: float, distance between the scale bars and the text content on the scale bars
            scale_font_size: float, font size of the text content on the scale bars, approximately equals to the height of the text content, refer to BOSL2 documentation for more details
        Blade stand parameters:

        Handle parameters:
            handle_axis_x_position: float, x coordinate of the center of the handle axis
            handle_axis_z_position: float, z coordinate of the center of the handle axis
            handle_axis_diameter: float, diameter of the handle axis
            handle_axis_hole_tolerance: float, tolerance for the hole of the handle axis, positive values will make the hole larger, while negative values will make the hole smaller
    */

    // define internal variables
    slot_top_corner_fillet_length = slot_top_corner_fillet / tan(slot_bottom_angle/2);


    // build the base of the body
    union() {
        // main base body
        difference() {
            // base cuboid
            make_chamfered_cube_with_round_corners(
                length = length, 
                width = width, 
                height = base_height, 
                corner_fillet = base_corner_fillet, 
                edge_chamfer = base_edge_chamfer
            );

            // slot for the reed holder
            translate([length+0.01, width/2, base_height+0.01])
                union() {
                    // slot
                    prismoid(
                        size2=[slot_length+0.01,slot_top_width-0.02/tan(slot_bottom_angle)], 
                        h=slot_height+0.01, 
                        xang=[90,90], 
                        yang=[slot_bottom_angle,slot_bottom_angle], 
                        anchor=RIGHT+TOP
                    );
                    // fillet the two top edges of the slot
                    translate([0,-(slot_top_width/2+slot_top_corner_fillet_length)+0.01,0]) rotate([-90,0,0])
                        rounding_edge_mask(l=slot_length, r=slot_top_corner_fillet+0.01, ang=slot_bottom_angle, orient=RIGHT, anchor=RIGHT+TOP);
                    
                    translate([0,+(slot_top_width/2+slot_top_corner_fillet_length)+0.01,0]) rotate([-90,0,0])
                        rounding_edge_mask(l=slot_length, r=slot_top_corner_fillet+0.01, ang=slot_bottom_angle, orient=LEFT, anchor=RIGHT+BOTTOM);
                }

        }

        // scale bars
        for(i = [scale_range[0]:1:scale_range[1]]){
            translate([scale_zero_x_position + i + scale_tolerance, width/2+slot_top_width/2+slot_top_corner_fillet_length, base_height-0.01])
            rotate([0,0,90])
                if(i % 10 == 0){
                    scale(length=scale_bar_major_length, width=scale_bar_width, height=scale_bar_height+0.01, content=str(i), content_bar_distance=scale_font_distance, font_size=scale_font_size);
                } else if(i % 5 == 0){
                    scale(length=scale_bar_submajor_length, width=scale_bar_width, height=scale_bar_height, content=false);
                } else if((i - 1) % 5 == 0){
                    scale(length=scale_bar_minor_length, width=scale_bar_width, height=scale_bar_height, content=false);
                } else {
                    scale(length=max(scale_bar_minor_length - scale_bar_minor_length_diff * abs(i - (floor(i/5)*5+1)), 0), width=scale_bar_width, height=scale_bar_height, content=false);
                }
        }
    }


    // build the blade stand
    union() {
        difference() {
            // basic cube
            translate([length-slot_length+0.01, width/2, base_height/2])
                cube([stand_length+0.01, width, stand_height+base_height/2], anchor=RIGHT+BOTTOM);

            // cut the handle axis hole
            translate([handle_axis_x_position, -0.01, handle_axis_z_position]) rotate([-90,0,0])
                cylinder(
                    h=width+0.02, 
                    r=handle_axis_diameter/2+handle_axis_hole_tolerance, 
                    anchor=BOTTOM);
        }
    }



}

$fa = 1;
$fn = 56;

build_body();