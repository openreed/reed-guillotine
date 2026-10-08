include <BOSL2/std.scad>


/*[形状参数 | Shape Parameters]*/
// 内部长度 | Inner length of the box
inner_length = 132.3;
// 内部宽度 | Inner width of the box
inner_width = 46.3;
// 内部高度 | Inner height of the box
inner_height = 52.2;

// 墙壁厚度 | Wall thickness
wall_thickness = 3.5;
// 底部厚度 | Bottom thickness
bottom_thickness = 2;
// 顶部厚度 | Top thickness
top_thickness = 2;

// 内部圆角半径 | Inner corner radius
inner_corner_radius = 10;
// 外部圆角半径 | Outer corner radius
outer_corner_radius = 5;


// 底部倒角 | Bottom Chamfer
bottom_chamfer = 2;
// 顶部倒角 | Top Chamfer
top_chamfer = 2;


/*[连接部参数 | Connection Parameters]*/

// 盒体壁高度 | Body wall height
body_wall_height = 40;
// 舌头（顶盖和盒体连接部）高度 | Tongue module height
tongue_height = 10;
// 舌头高度公差 | Tongue height tolerance
tongue_height_tolerance = 0.1;
// 顶盖壁厚度公差，越大越松 | Tolerance of the lid wall, the larger the looser.
lid_wall_thickness_tolerance = 0.1;
// 舌头厚度 | Tongue thickness
tongue_thickness = 1.7;


/*[OpenReed Logo 参数 ｜ OpenReed Logo Parameters]*/
// Logo 宽度占盒宽的比例 | Logo width ratio
logo_ratio = 0.5;
// Logo 深度 | Logo depth
logo_depth = 0.01;


/* [卡扣参数 | Snap-fit Parameters] */
// 卡扣角度，越大则越紧，越难以打开 | The angle of the snap-fit, the bigger the tighter.
snap_lock_angle = 72;
// 卡扣斜面角度 | Snap-fit slope angle
snap_slope_angle = 12;
// 卡扣深度 | Snap-fit depth
snap_depth = 1.2;
// 卡扣长度 | Snap-fit length
snap_length = 25;
// 卡扣公差 | Snap-fit tolerance
snap_tolerance = 0.1;
// 卡扣组数 | Number of snap-fit groups
snap_count = 1;
// 卡扣高度占舌头比例，越大卡扣位置越高 | Ratio between the snap lock height and the tongue height, the bigger the higher the snap lock position.
snap_tongue_ratio = 0.55;
// 盒体卡扣槽高度 | Snap slot height
snap_slot_height = 12;
 

/*[内部参数 | Internal Parameters]*/
outer_length = inner_length + 2*wall_thickness;
outer_width = inner_width + 2*wall_thickness;
outer_height = inner_height + bottom_thickness + top_thickness;
lid_wall_height = inner_height - body_wall_height + tongue_height;
snap_height = (snap_depth/tan(snap_lock_angle)) + (snap_depth/tan(snap_slope_angle));




module rounded_edge_chamfer_mask(
    length, width, corner_fillet, edge_chamfer
){
    //// Bottom Edges
    translate([length/2, 0, 0])
        chamfer_edge_mask(l = length, chamfer=edge_chamfer, orient=RIGHT);
    translate([0, width/2, 0])
        chamfer_edge_mask(l = width, chamfer=edge_chamfer, orient=FRONT);
    translate([length, width/2, 0])
        chamfer_edge_mask(l = width, chamfer=edge_chamfer, orient=BACK);
    translate([length/2, width, 0])
        chamfer_edge_mask(l = length, chamfer=edge_chamfer, orient=LEFT);
    //// Bottom Corners
    translate([corner_fillet,corner_fillet,0])
        rotate_extrude(angle=90, start=0, $fa=0.5, $fs=0.1) left(corner_fillet) zrot(45) square(edge_chamfer * sqrt(2), center=true, $fa=0.5, $fs=0.1);
    translate([length-corner_fillet,corner_fillet,0])
        rotate_extrude(angle=90, start=90, $fa=0.5, $fs=0.1) left(corner_fillet) zrot(45) square(edge_chamfer * sqrt(2), center=true, $fa=0.5, $fs=0.1);
    translate([length-corner_fillet,width-corner_fillet,0])
        rotate_extrude(angle=90, start=180, $fa=0.5, $fs=0.1) left(corner_fillet) zrot(45) square(edge_chamfer * sqrt(2), center=true, $fa=0.5, $fs=0.1);
    translate([corner_fillet,width-corner_fillet,0])
        rotate_extrude(angle=90, start=270, $fa=0.5, $fs=0.1) left(corner_fillet) zrot(45) square(edge_chamfer * sqrt(2), center=true, $fa=0.5, $fs=0.1);
}


module openreed_logo(height, thickness){
    top_width = height * 4.0 / 6.2;
    bottom_width = height * 2.4 / 6.2;

    linear_extrude(height = thickness) 
        trapezoid(
            h = height,
            w1 = bottom_width,
            w2 = top_width,
        );
}


module snap_prism(lock_angle, slope_angle, depth){
    rotate([-90, 90, 0])
        prismoid(
            size2=[0, snap_length], 
            xang=[lock_angle, slope_angle],
            yang=90,
            h=depth,
        );
}


module snap_slot(
    x, sign_y,
) {
    translate([
        x, 
        sign_y * (inner_width/2+tongue_thickness), 
        bottom_thickness+body_wall_height-tongue_height+0.01
    ])
        if (sign(sign_y)==-1) {
            cuboid(
                size=[snap_length, wall_thickness-tongue_thickness+0.01, snap_slot_height+0.01],
                anchor=TOP+BACK,
            );
        }
        else {
            cuboid(
                size=[snap_length, wall_thickness-tongue_thickness+0.01, snap_slot_height+0.01],
                anchor=TOP+FRONT,
            );
        }
        
    translate([
        x, 
        sign_y * (outer_width/2),
        bottom_thickness+body_wall_height-tongue_height - snap_slot_height,
    ])
        cylinder(
            h = snap_length,
            r = wall_thickness-tongue_thickness,
            orient=RIGHT,
            anchor=CENTER,
            $fa = 0.5,
            $fs = 0.1
        );
}




module box_body(){
    difference(){
        union(){
            cuboid(
                size = [outer_length, outer_width, bottom_thickness + body_wall_height - tongue_height],
                rounding = outer_corner_radius,
                edges="Z",
                anchor=BOTTOM,
                $fa=0.5,
                $fs=0.1,
            );
            // tongue
            cuboid(
                size = [inner_length+2*tongue_thickness, inner_width+2*tongue_thickness, bottom_thickness + body_wall_height],
                rounding = inner_corner_radius,
                edges="Z",
                anchor=BOTTOM,
                $fa=0.5,
                $fs=0.1,
            );
        }

        // inner space
        translate([0,0,bottom_thickness])
            cuboid(
                size = [inner_length, inner_width, body_wall_height+0.01],
                rounding = inner_corner_radius,
                edges="Z",
                anchor=BOTTOM,
                $fa=0.5,
                $fs=0.1,
            );
        
        // chamfer
        translate([-outer_length/2, -outer_width/2, 0])
            rounded_edge_chamfer_mask(
                length = outer_length,
                width = outer_width,
                corner_fillet = outer_corner_radius,
                edge_chamfer = bottom_chamfer
            );
        
        // snap-fit
        for (i=[1:1:snap_count]) {
            snap_x_position = i/(snap_count+1) * (inner_length + 2*tongue_thickness) - inner_length/2 - tongue_thickness;
            translate([snap_x_position, -inner_width/2-tongue_thickness-0.01, bottom_thickness+body_wall_height-tongue_height*(1-snap_tongue_ratio)])
                snap_prism(snap_lock_angle, snap_slope_angle, snap_depth+0.01);
            translate([snap_x_position, inner_width/2+tongue_thickness+0.01, bottom_thickness+body_wall_height-tongue_height*(1-snap_tongue_ratio)])
            rotate([0, 0, 180])
                snap_prism(snap_lock_angle, snap_slope_angle, snap_depth+0.01);
        }

        // snap cut
        for (i=[1:1:snap_count]) {
            snap_x_position = i/(snap_count+1) * (inner_length + 2*tongue_thickness) - inner_length/2 - tongue_thickness;
            snap_slot(
                x=snap_x_position,
                sign_y=-1
            );
            snap_slot(
                x=snap_x_position,
                sign_y=1
            );

        }

    }

}


module box_lid(){
    union(){
        difference(){
            cuboid(
                size = [outer_length, outer_width, top_thickness + lid_wall_height],
                rounding = outer_corner_radius,
                edges="Z",
                anchor=BOTTOM,
                $fa=0.5,
                $fs=0.1,
            );
        
            // inner space
            translate([0,0,top_thickness])
                cuboid(
                    size = [inner_length, inner_width, lid_wall_height+0.01],
                    rounding = inner_corner_radius,
                    edges="Z",
                    anchor=BOTTOM,
                    $fa=0.5,
                    $fs=0.1,
                );

            // tongue
            translate([0,0,top_thickness + lid_wall_height - tongue_height - tongue_height_tolerance])
                cuboid(
                    size = [
                        inner_length+2*tongue_thickness+2*lid_wall_thickness_tolerance, 
                        inner_width+2*tongue_thickness+2*lid_wall_thickness_tolerance, 
                        tongue_height+tongue_height_tolerance+0.01
                    ],
                    rounding = inner_corner_radius,
                    edges="Z",
                    anchor=BOTTOM,
                    $fa=0.5,
                    $fs=0.1,
                );

            // chamfer
            translate([-outer_length/2, -outer_width/2, 0])
                rounded_edge_chamfer_mask(
                    length = outer_length,
                    width = outer_width,
                    corner_fillet = outer_corner_radius,
                    edge_chamfer = top_chamfer
                );

            // openreed logo
            translate([0,0,-0.01]) rotate([0,0,180])
                openreed_logo(height = logo_ratio*outer_width, thickness = logo_depth+0.01);

        }

        // snap fit
        for (i=[1:1:snap_count]) {
            snap_x_position = i/(snap_count+1) * (inner_length + 2*tongue_thickness) - inner_length/2 - tongue_thickness;
            translate([snap_x_position, -inner_width/2-tongue_thickness-lid_wall_thickness_tolerance-0.01, top_thickness+lid_wall_height-tongue_height*(snap_tongue_ratio)])
            rotate([0, 180, 0])
                snap_prism(snap_lock_angle, snap_slope_angle, snap_depth+0.01 - snap_tolerance);
            translate([snap_x_position, inner_width/2+tongue_thickness+lid_wall_thickness_tolerance+0.01, top_thickness+lid_wall_height-tongue_height*(snap_tongue_ratio)])
            rotate([0, 0, 180])
            rotate([0, 180, 0])
                snap_prism(snap_lock_angle, snap_slope_angle, snap_depth+0.01 - snap_tolerance);
        }
    }
}

translate([0, outer_width/2 + 10, 0])
    box_lid();

translate([0, -outer_width/2 - 10, 0])
    box_body();
