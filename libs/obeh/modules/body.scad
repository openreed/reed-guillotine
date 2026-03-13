// This file models the main body of the guillotine for oboe and English horn.

include <BOSL2/std.scad>

use <../../utils/utils.scad>


module notch(length, width, height, 
             content, content_bar_distance, font_size) {
    /*
    This module models the scale notch of the guillotine.
          +-------------------+
    width |(origin)           | {content}
          +-------------------+
                 length
    
    Args:
        length: float, length of the scale bar
        width: float, width of the scale bar
        height: float, height of the scale bar
        content: string, text content on the scale bar
        content_bar_distance: float, distance between the scale bar and the text content
        font_size: float, font size of the text content, approximately equals to the height of the text content, refer to BOSL2 documentation for more details
    */
    union() {
        // Scale bar
        cube([length, width, height], anchor=LEFT+BOTTOM);
        
        // Text content
        translate([length + content_bar_distance, 0, 0])
            text3d(content, h=height, size=font_size, anchor=LEFT+BOTTOM, atype="ycenter");
    }
}


module build_body(
    length=132, width=46, base_height=10, base_corner_fillet=10, base_edge_chamfer=1,
    slot_top_width=16, slot_bottom_width=18, slot_length=92, slot_height=4, slot_corner_fillet=1,

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
        slot_bottom_width: float, width of the bottom of the slot for the reed holder
        slot_length: float, length of the slot for the reed holder
        slot_height: float, height of the slot for the reed holder
        slot_corner_fillet: float, fillet radius of the two bottom corners of the slot for the reed holder

    */


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

        }


        // notches


    }




    // build the blade bridge



}

