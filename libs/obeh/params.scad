// 该文件包括了哨片断头台的参数 | This file includes parameters of the guillotine for the blade.

/*[公差 | Tolerances]*/
// 刻度的公差，正值会使刻度远离零刻线，负值会使刻度靠近零刻线 | Tolerance of the scale, positive values will make the scale bars come farther from the zero point, while negative values will make the scale bars come closer to the zero point
scale_tolerance=0.3;
// 刀片长度公差 | Tolerance of the length of the blade
blade_length_tolerance=0.4;
// 刀片侧面缺口卡座的公差 | Tolerance of the side notch clamp on the blade holder
side_notch_tolerance=0.1;
// 刀片夹背的厚度公差 | Thickness tolerance of the back clamp for the blade, positive values will make the back clamp thicker and negative values will make the back clamp thinner
back_clamp_thickness_tolerance=0.5;
// 刀片侧面缺口卡座的公差 | Tolerance of the side notch clamp on the blade holder
back_clamp_width_tolerance=0.3;
// 底部刀片座相对于刀片+夹片的厚度所增加的长度 | Length of the bottom blade clamp, which is the part of the blade that protrudes from the blade holder and can cut the reed
bottom_blade_seat_tolerance=0.1;
// 手柄转轴孔公差 | Tolerance of the hole for the handle axis
handle_axis_hole_tolerance=0.1;
// 手柄转轴长度公差 | Tolerance of the length of the handle axis, positive values will make the handle axis longer and negative values will make the handle axis shorter
handle_axis_length_tolerance=0.2;
// 顶部刀片夹具滑槽的公差 | Tolerance of the slot for the upper blade holder
upper_blade_holder_slot_tolerance=0.2;
// 手柄和墙公差 | Tolerance between the handle and the walls, positive values will make the handle farther from the walls and negative values will make the handle closer to the walls
handle_wall_tolerance=0.5;
// 手柄孔公差 | Tolerance of the hole for the handle axis
handle_hole_tolerance=0.2;
// 哨片座宽度公差，用于和滑槽的配合 | Tolerance of the width of the reed holder, for assemblying with the slot on the base.
reed_holder_width_tolerance=0.2;

/*[基座参数 | Base Parameters]*/
// 基座长度，也是总长度 | Length of the base
length=132;  
// 基座宽度，也是总宽度 | Width of the base
width=46;
// 基座高度 | Height of the base
base_height=10;
// 基座边角的圆角半径 | Fillet radius of the corners of the base
base_corner_fillet=10;
// 基座边缘的倒角距离 | Chamfer distance of the edges of the base
base_edge_chamfer=1;
// 基座底部空洞的长度 | Length of the hole at the bottom of the base
bottom_hole_length=10;

/*[滑槽参数 | Slot Parameters]*/
// 滑槽顶部的宽度 | Width of the top of the slot for the reed holder
slot_top_width=16;
// 滑槽底部与侧面的夹角，单位为度 | Angle between the bottom and the side of the slot for the reed holder, in degree
slot_bottom_angle=72;
// 滑槽长度 | Length of the slot for the reed holder
slot_length=92;
// 滑槽高度 | Height of the slot for the reed holder
slot_height=4;
// 滑槽顶部两个边缘的圆角半径 | Fillet radius of the two top edges of the slot for the reed holder
slot_top_corner_fillet=0.4;

/*[刻度参数 | Scale Parameters]*/
// 刻度零点的x坐标，即刀片所在位置的坐标 | x position of the zero point of the scale, i.e., the coordinate of the blade
scale_zero_x_position=37;
// 刻度零点的z坐标，即刀片顶部高度 | z position of the zero point of the scale, i.e., the height of the top of the blade
scale_zero_z_position=20;
// 刻度的范围，单位为毫米 | Range of the scale, in millimeter
scale_range=[30,80];
// 主要刻度线的长度，即那些刻度值为10的倍数的刻度线的长度 | Length of the scale bars for those scale values that are multiples of 10, i.e., 30, 40, 50
scale_bar_major_length=5.8;
// 次要刻度线的长度，即那些刻度值为5的倍数但不是10的倍数的刻度线的长度 | Length of the scale bars for those scale values that are multiples of 5 but not multiples of 10, i.e., 35, 45, 55
scale_bar_submajor_length=5.0;
// 其他刻度线的长度，即那些刻度值满足{value - 1 mod 5 == 0}的刻度线的长度 | Length of the scale bars for those scale values satisfying {value - 1 mod 5 == 0}, i.e., 31, 36, 41, 46, 51
scale_bar_minor_length=4.4;
// 其他刻度线的长度差值，即那些刻度值不满足{value - 1 mod 5 == 0}的刻度线的长度等于{scale_bar_minor_length - scale_bar_minor_length_diff * x}，
scale_bar_minor_length_diff=0.35;
// 刻度线的宽度 | Width of the scale bars
scale_bar_width=0.4;
// 刻度线的高度 | Height of the scale bars
scale_bar_height=0.4;
// 刻度线与刻度值文本之间的距离 | Distance between the scale bars and the text content on the scale bars
scale_font_distance=0.4;
// 刻度值文本的字体大小，单位为毫米，近似等于刻度值文本的高度，具体参见BOSL2文档 | Font size of the text content on the scale bars, in millimeter, approximately equals to the height of the text content, refer to BOSL2 documentation for more details
scale_font_size=4.6;

/*[刀片参数 | Blade Parameters]*/
// 刀片长度 | Length of the blade
blade_length=39;
// 刀片宽度 | Width of the blade
blade_width=19;
// 刀片厚度 | Thickness of the blade
blade_thickness=0.23;
// 刀片上孔的直径 | Diameter of the hole on the blade
hole_diameter=2;
// 刀片上孔中心到刀刃的距离 | Distance between the center of the hole on the blade and the edge of the blade
hole_edge_distance=7;
// 刀片侧面缺口的宽度 | Width of the side notch on the blade
side_notch_width=2.5;
// 刀片侧面缺口的长度 | Length of the side notch on the blade
side_notch_length=3.5;
// 刀片侧面缺口中心到刀刃的距离 | Distance between the center of the side notch on the blade and the edge of the blade
side_notch_edge_distance=9.6;
// 刀片背部夹具的厚度 | Thickness of the back clamp for the blade
back_clamp_thickness=0.1;
// 刀片背部夹具的宽度 | Width of the back clamp for the blade
back_clamp_width=7;


/*[刀片夹具参数 | Blade Holder Parameters]*/
// 刀片突出部分的长度 | Length of the blade protrusion, which is the part of the blade that protrudes from the blade holder and can cut the reed
blade_protrusion_length=2;
// 刀片侧面缺口卡座的高度 | Height of the side notch clamp on the blade holder
side_notch_height=2;
// 刀片夹片的高度 | Height of the blade clamp
blade_clamp_height=2;


/*[顶部刀片夹具参数 | Upper Blade Holder Parameters]*/
// 顶部刀片夹具的基座高度 | Base height of the upper blade holder
upper_blade_holder_base_height=2;
// 顶部刀片夹具的滑块尺寸 | Slider size of the upper blade holder
upper_blade_holder_slider_size=4;
// 顶部刀片夹具的滑块长度 | Slider length of the upper blade holder
upper_blade_holder_slider_length=10;
// 顶部刀片夹具的两个滑块的中心间距 | Center distance between the two sliders of the upper blade holder
upper_blade_holder_slider_spacing=25;
// 顶部刀片夹具滑槽的深度 | Depth of the slot for the upper blade holder
upper_blade_holder_slot_depth=20;


/*[弹簧参数 | Spring Parameters]*/
// 弹簧座直径 | Diameter of the spring seat for the upper blade holder
spring_seat_diameter=2.5;
// 弹簧座高度 | Height of the spring seat for the upper blade holder
spring_seat_height=3;


/*[墙参数 | Wall Parameters]*/
// 墙长度 | Length of the walls
wall_length=20;
// 墙厚度 | Thickness of the walls
wall_thickness=15;
// 墙与夹具之间的距离 | Distance between the walls and the blade holder
wall_holder_distance=3;
// 墙上螺丝孔中心到墙边的距离 | Distance between the center of the screw holes on the walls and the side of the walls
wall_screw_center_side_distance=5;
// 墙上多组螺丝孔的x坐标，list | x positions of the sets of screw holes on the walls, in a list
wall_screw_x_positions=[28];
// 墙上螺丝孔的类型 "型号，深度" | Type of the screw holes on the walls, in the format of "type, depth"
wall_screw_type="M5,10";
// 墙上公凸中心到后墙的距离 | Distance between the center of the wall tongue and the back wall
wall_tongue_center_back_distance=4;
// 墙上公凸的高度 | Height of the wall tongue
wall_tongue_height=3;
// 墙上公凸的直径 | Diameter of the wall tongue
wall_tongue_diameter=5;
// 墙前档板的厚度 | Thickness of the wall front skirt
wall_skirt_thickness=3;


/*[手柄参数 | Handle Parameters]*/
// 手柄转轴中心x坐标 | x position of the center of the handle axis
handle_axis_x_position=21;
// 手柄转轴中心z坐标 | z position of the center of the handle axis
handle_axis_z_position=29;
// 手柄转轴直径 | Diameter of the handle axis
handle_axis_diameter=10;
// 手柄转轴长度 | Length of the handle axis
handle_axis_length=30;
// 手柄转轴倒角 | Chamfer of the handle axis
handle_axis_chamfer=1;
// 手柄轴心到末端的水平距离 | The horizontal distance from the center of the handle axis to the end of the handle
handle_axis_to_end_distance=60;
// 手柄轴心到顶部边缘的垂直距离 | The vertical distance from the center of the handle axis to the top edge of the handle
handle_axis_to_top_distance=12;
// 手柄厚度 | Thickness of the handle
handle_thickness=8;
// 手柄倒角 | Chamfer of the handle
handle_chamfer=0.8;
// 手柄孔的墙厚 | Wall thickness of the handle hole
handle_hole_wall_thickness=2;


/*[顶盖参数 | Lid Parameters]*/
// 顶盖高度，应大于wall_tongue_height | Height of the lid, should be greater than wall_tongue_height
lid_height=5;
// 顶盖上螺丝顶孔深度 | Depth of the screw slots on the lid
lid_screw_slot_head_depth=3;
// 顶盖上螺丝顶孔直径 | Diameter of the screw slots on the lid
lid_screw_slot_head_diameter=7;
// 顶盖上螺丝孔的直径 | Diameter of the screw slots on the lid
lid_screw_slot_diameter=5.2;
// 顶盖上凹槽直径公差 | Tolerance of the groove diameter on the lid
lid_groove_diameter_tolerance=0.2;
// 顶盖上凹槽高度公差 | Tolerance of the groove height on the lid
lid_groove_height_tolerance=0.5;


/*[哨片座参数 | Reed Holder Parameters]*/
// 哨片座长度 | Length of the reed holder
reed_holder_length=40;
// 哨片座高度 | Height of the reed holder
reed_holder_height=15;
// 哨片座圆角 | Fillet radius of the reed holder
reed_holder_fillet=0.5;
// 哨座槽长度 | Length of the staple slot on the reed holder
staple_slot_length=23;
// 哨座槽半径 | Diameter of the staple slot
staple_slot_diameter=5.8;
// 哨片座螺孔类型 "型号" | Type of the screw holes on the reed holder, in the format of "type"
reed_holder_screw_type="M10";
// 哨片座螺孔x坐标 | x position of the screw holes on the reed holder
reed_holder_screw_x_position=30;
// 哨片锥槽深度 | Depth of the mandrel slot
mandrel_slot_depth=3.5;
// 哨片锥槽直径 | Diameter of the mandrel slot
mandrel_slot_diameter=7.1;
// 哨片锥直径 | Diameter of the mandrel
mandrel_diameter=4.6;
// 固定螺丝头部宽度 | Diameter of the head of the tightening screw
tightening_screw_head_diameter=15;
// 固定螺丝头部高度 | Height of the head of the tightening screw
tightening_screw_head_height=10;



/*[内部参数 | Internal Parameters]*/
slot_top_corner_fillet_length = slot_top_corner_fillet / tan(slot_bottom_angle/2);
cutting_block_length = length - slot_length - blade_thickness/2 - scale_zero_x_position;
wall_height = handle_axis_z_position + handle_axis_diameter/2 + handle_axis_hole_tolerance/2 - base_height;
wall_right_x_position = scale_zero_x_position - blade_thickness/2 - blade_clamp_height - bottom_blade_seat_tolerance-wall_holder_distance;
wall_total_length = wall_length + wall_skirt_thickness + (length-slot_length-wall_right_x_position);
// 手柄宽度 | Width of the handle
handle_width=width-2*wall_thickness-handle_wall_tolerance;
// 哨片座宽度 | Width of the reed holder
reed_holder_width=slot_top_width-reed_holder_width_tolerance;
// 刀片槽长度 | Length of the blade slot
blade_slot_length=blade_length+blade_length_tolerance;
