include <BOSL2/std.scad>


module make_chamfered_cube_with_round_corners(
    length, width, height, 
    corner_fillet, edge_chamfer
) {
    /*
    This module models a cube with chamfered edges and rounded corners.

    Args:
        length: float, length of the cube
        width: float, width of the cube
        height: float, height of the cube
        corner_fillet: float, fillet radius of the corners of the cube
        edge_chamfer: float, chamfer distance of the edges of the cube

    */

    // build the base of the body
    difference(){
        // Base Cuboid
        cuboid(
            size=[length, width, height], 
            anchor=BOTTOM+FRONT+LEFT,
            rounding=corner_fillet,
            edges="Z"
        );
        

        // Chamfer Edges

        //// Bottom Edges
        translate([length/2, 0, 0])
            chamfer_edge_mask(l = length, chamfer=edge_chamfer, orient=RIGHT);
        translate([0, width/2, 0])
            chamfer_edge_mask(l = width, chamfer=edge_chamfer, orient=FRONT);
        translate([length, width/2, 0])
            chamfer_edge_mask(l = width, chamfer=edge_chamfer, orient=BACK);
        translate([length/2, width, 0])
            chamfer_edge_mask(l = length, chamfer=edge_chamfer, orient=LEFT);
        //// Top Edges
        translate([length/2, 0, height])
            chamfer_edge_mask(l = length, chamfer=edge_chamfer, orient=RIGHT);
        translate([0, width/2, height])
            chamfer_edge_mask(l = width, chamfer=edge_chamfer, orient=FRONT);
        translate([length, width/2, height])
            chamfer_edge_mask(l = width, chamfer=edge_chamfer, orient=BACK);
        translate([length/2, width, height])
            chamfer_edge_mask(l = length, chamfer=edge_chamfer, orient=LEFT);
        //// Bottom Corners
        translate([corner_fillet,corner_fillet,0])
            rotate_extrude(angle=90, start=0) left(corner_fillet) zrot(45) square(edge_chamfer * sqrt(2), center=true);
        translate([length-corner_fillet,corner_fillet,0])
            rotate_extrude(angle=90, start=90) left(corner_fillet) zrot(45) square(edge_chamfer * sqrt(2), center=true);
        translate([length-corner_fillet,width-corner_fillet,0])
            rotate_extrude(angle=90, start=180) left(corner_fillet) zrot(45) square(edge_chamfer * sqrt(2), center=true);
        translate([corner_fillet,width-corner_fillet,0])
            rotate_extrude(angle=90, start=270) left(corner_fillet) zrot(45) square(edge_chamfer * sqrt(2), center=true);
        //// Top Corners
        translate([corner_fillet,corner_fillet,height])
            rotate_extrude(angle=90, start=0) left(corner_fillet) zrot(45) square(edge_chamfer * sqrt(2), center=true);
        translate([length-corner_fillet,corner_fillet,height])
            rotate_extrude(angle=90, start=90) left(corner_fillet) zrot(45) square(edge_chamfer * sqrt(2), center=true);
        translate([length-corner_fillet,width-corner_fillet,height])
            rotate_extrude(angle=90, start=180) left(corner_fillet) zrot(45) square(edge_chamfer * sqrt(2), center=true);
        translate([corner_fillet,width-corner_fillet,height])
            rotate_extrude(angle=90, start=270) left(corner_fillet) zrot(45) square(edge_chamfer * sqrt(2), center=true);
    }
}

