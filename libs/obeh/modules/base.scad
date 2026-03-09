// This file models the base of the guillotine for oboe and English horn.

include <BOSL2/std.scad>


module notch(length, width, height, rotation, 
             content, content_bar_distance,) {
    /*
    This module models the scale notch of the guillotine.
          +-------------------+
    width |                   | {content}
          +-------------------+
                 length
    
    Args:
        length: float, length of the scale bar
        width: float, width of the scale bar
        height: float, height of the scale bar
        rotation: [float, float, float], rotation angles of the scale bar in degrees, consistent with OpenSCAD's rotate() function
        content: string, text content on the scale bar
        content_bar_distance: float, distance between the scale bar and the text content
    */



}

