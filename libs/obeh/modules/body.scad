// This file models the main body of the guillotine for oboe and English horn.

include <BOSL2/std.scad>

include <../params.scad>
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


module build_body() {
    /*
    This module models the base of the guillotine for oboe and English horn.
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
                        rounding_edge_mask(l=slot_length+0.01, r=slot_top_corner_fillet+0.01, ang=slot_bottom_angle, orient=RIGHT, anchor=RIGHT+TOP);
                    
                    translate([0,+(slot_top_width/2+slot_top_corner_fillet_length)+0.01,0]) rotate([-90,0,0])
                        rounding_edge_mask(l=slot_length+0.01, r=slot_top_corner_fillet+0.01, ang=slot_bottom_angle, orient=LEFT, anchor=RIGHT+BOTTOM);
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


}

$fa = 1;
$fn = 56;

build_body();