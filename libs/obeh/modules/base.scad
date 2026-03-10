// This file models the base of the guillotine for oboe and English horn.

include <BOSL2/std.scad>


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
