// This file models the main body of the guillotine for oboe and English horn.

include <BOSL2/std.scad>

use <../../utils/utils.scad>


module scale(length, width, height, 
             content, content_bar_distance, font_size) {
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
    length=132, width=46, base_height=10, base_corner_fillet=10, base_edge_chamfer=1,
    slot_top_width=16, slot_bottom_angle=72, slot_length=92, slot_height=4, slot_top_corner_fillet=1,
    scale_zero_x_position=0, scale_tolerance=0.3,
) {
    /*
    This module models the base of the guillotine for oboe and English horn.

    Args:
        length: float, length of the base
        width: float, width of the base
        base_height: float, height of the base
        base_corner_fillet: float, fillet radius of the corners of the base
        base_edge_chamfer: float, chamfer distance of the edges of the base

        slot_top_width: float, width of the top of the slot for the reed holder
        slot_bottom_angle: float, angle between the bottom and the side of the slot for the reed holder, in degree
        slot_length: float, length of the slot for the reed holder
        slot_height: float, height of the slot for the reed holder
        slot_top_corner_fillet: float, fillet radius of the two top edges of the slot for the reed holder

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



    }




    // build the blade bridge



}

$fa = 1;
$fn = 56;

build_body();