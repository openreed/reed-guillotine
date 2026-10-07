use <./modules/body.scad>
use <./modules/blade_holder.scad>
use <./modules/cutting_block.scad>
use <./modules/blade.scad>
use <./modules/handle.scad>
use <./modules/lid.scad>
use <./modules/reed_holder.scad>
use <../utils/utils.scad>


include <BOSL2/std.scad>
include <BOSL2/screws.scad>

include <params.scad>


// main body
build_body();


// bottom blade settings
translate([scale_zero_x_position, width/2, scale_zero_z_position]) 
rotate([90,0,90]) 
    color(c = [0.9,0.9,0.9])
    blade();

translate([scale_zero_x_position - blade_thickness/2 - blade_clamp_height, width/2, scale_zero_z_position-blade_width])
rotate([90,0,90]) 
    bottom_blade_clamp();


// cutting block settings
translate([scale_zero_x_position - blade_thickness/2 + cutting_block_front_back_fit_tolerance, width/2, base_height+wall_height])
rotate([180,0,-90])
    cutting_block();


// handle settings
translate([handle_axis_x_position, handle_axis_length/2 + width/2, handle_axis_z_position])
rotate([90,0,0])
    axle();

translate([handle_axis_x_position, handle_width/2 + width/2, handle_axis_z_position])
rotate([
    90,
    -handle_rotate_angle(
        x=wall_right_x_position - handle_axis_x_position, 
        y=base_height + wall_height - handle_axis_z_position,
        z=handle_axis_to_top_distance - handle_thickness,
    ),
    0
])
    handle();


// lid settings
translate([0,0,base_height+wall_height])
    lid();


// reed holder settings
translate([66, width/2, base_height-slot_height])
reed_holder();

translate([66 + reed_holder_screw_x_position, width/2, tightening_screw_head_height+tightening_screw_height+base_height-slot_height])
rotate([180,0,0])
    tightening_screw();


echo("Cutting block travel:", cutting_block_travel_distance);
