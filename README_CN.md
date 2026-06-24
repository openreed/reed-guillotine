# Reed Guillotine

[[English](README.md) | [以中文阅读](README_CN.md)]

> 本仓库是 OpenReed 簧片断头台的 OpenSCAD 参数化模型源码。
> 产品介绍请访问[项目主页](https://openreed.github.io/oboe/reed-guillotine/)。

---

## 目录

- [生成 3D 模型文件](#生成-3d-模型文件)
- [参数说明](#参数说明)
  - [公差参数](#公差参数)
  - [基座参数](#基座参数)
  - [滑槽参数](#滑槽参数)
  - [刻度参数](#刻度参数)
  - [刀片参数](#刀片参数)
  - [刀片夹具参数](#刀片夹具参数)
  - [顶部刀片夹具参数](#顶部刀片夹具参数)
  - [弹簧参数](#弹簧参数)
  - [墙参数](#墙参数)
  - [手柄参数](#手柄参数)
  - [顶盖参数](#顶盖参数)
  - [哨片座参数](#哨片座参数)
- [3D 打印建议](#3d-打印建议)
- [项目结构](#项目结构)

---

## 生成 3D 模型文件

### 前置依赖

- [OpenSCAD](https://openscad.org/)（推荐通过 Homebrew 安装：`brew install openscad`）
- Python 3
- OpenSCAD 库依赖：本项目的模块使用 [BOSL2](https://github.com/revarbat/BOSL2) 库，请确保 OpenSCAD 库路径中已安装。可通过以下方式安装：

  ```bash
  # 使用 OpenSCAD 内置库管理器安装 BOSL2
  # 或在 OpenSCAD 中打开 Library Manager，搜索 BOSL2 并安装
  ```

### 使用渲染脚本

项目提供了 `render.py` 脚本，可一键渲染所有部件为 STL 文件。

```bash
# 渲染 oboe/English horn 版本的所有零件
python render.py obeh

# 仅渲染指定零件（逗号分隔）
python render.py obeh --parts body,lid,handle

# 仅渲染装配体（不包含单个零件）
python render.py obeh --assembly-only

# 指定输出目录
python render.py obeh --output ./my_stls

# 查看可用的模型版本
python render.py --list-versions
```

渲染完成后，STL 文件默认输出至 `3D_files/obeh/` 目录。

### 直接下载预生成文件

也可从以下平台直接下载预先生成的 `.3mf` 文件：

| 平台 | 链接 |
|------|------|
| MakerWorld Global | [下载](https://makerworld.com/) |
| MakerWorld CN | [下载](https://makerworld.com.cn/) |

---

## 参数说明

所有参数定义在 `libs/obeh/params.scad` 中，按功能分组如下。

### 公差参数

这些参数用于微调零件配合，根据实际打印效果和组装体验进行调整。

| 参数名 | 默认值 | 说明 |
|--------|--------|------|
| `scale_tolerance` | 0.3 | 刻度公差。正值使切出的哨片更长，负值使其更短 |
| `blade_length_tolerance` | 1.0 | 刀片长度公差 |
| `side_notch_tolerance` | 0.1 | 刀片侧面缺口卡座公差 |
| `back_clamp_thickness_tolerance` | 0.1 | 刀片夹背厚度公差。正值使背夹更厚，负值更薄 |
| `back_clamp_width_tolerance` | 0.3 | 刀片夹背宽度公差 |
| `bottom_blade_seat_tolerance` | 0.1 | 底部刀片座伸出长度公差 |
| `handle_axis_hole_tolerance` | 0.05 | 手柄转轴孔公差 |
| `handle_axis_length_tolerance` | 0.2 | 手柄转轴长度公差。正值使转轴更长 |
| `upper_blade_holder_slot_tolerance` | 0.2 | 顶部刀片夹具滑槽公差 |
| `upper_blade_holder_width_tolerance` | 0.6 | 顶部刀片夹具宽度公差，控制滑动配合 |
| `lid_groove_diameter_tolerance` | 0.1 | 顶盖凹槽直径公差 |
| `lid_groove_height_tolerance` | 0.5 | 顶盖凹槽高度公差 |
| `handle_wall_tolerance` | 0.4 | 手柄与墙之间的间隙公差。正值使手柄离墙更远 |
| `handle_hole_tolerance` | 0.2 | 手柄孔公差 |
| `reed_holder_width_tolerance` | -0.05 | 哨片座宽度公差，用于和滑槽配合 |
| `blade_engagement_tolerance` | 0.2 | 刀片咬合公差。越大则顶部刀片最低位置越高，两刀片越不容易咬合 |
| `blade_front_back_fit_tolerance` | 0.3 | 刀片前后配合公差。越大则顶部刀片相对底部刀片的 x 位置越大 |

### 基座参数

| 参数名 | 默认值 | 说明 |
|--------|--------|------|
| `length` | 132 | 基座长度（也是总长度） |
| `width` | 46 | 基座宽度（也是总宽度） |
| `base_height` | 14 | 基座高度 |
| `base_corner_fillet` | 10 | 基座边角圆角半径 |
| `base_edge_chamfer` | 1 | 基座边缘倒角距离 |
| `bottom_hole_length` | 12 | 基座底部空洞长度 |
| `screw_driver_slot_height` | 8 | 基座螺丝刀避让槽高度 |

### 滑槽参数

| 参数名 | 默认值 | 说明 |
|--------|--------|------|
| `slot_top_width` | 16 | 滑槽顶部宽度 |
| `slot_bottom_angle` | 72 | 滑槽底部与侧面夹角（度） |
| `slot_length` | 92 | 滑槽长度 |
| `slot_height` | 6 | 滑槽高度 |
| `slot_top_corner_fillet` | 0.4 | 滑槽顶部边缘圆角半径 |

### 刻度参数

| 参数名 | 默认值 | 说明 |
|--------|--------|------|
| `scale_zero_x_position` | 37 | 刻度零点 x 坐标（刀片位置） |
| `scale_zero_z_position` | 20 | 刻度零点 z 坐标（刀片顶部高度） |
| `scale_range` | [30, 80] | 刻度范围（毫米） |
| `scale_bar_major_length` | 5.4 | 主刻度线长度（10 的倍数，如 30、40） |
| `scale_bar_submajor_length` | 4.6 | 次刻度线长度（5 的倍数但非 10 的倍数，如 35、45） |
| `scale_bar_minor_length` | 4.0 | 小刻度线长度（满足 value-1 mod 5 == 0，如 31、36） |
| `scale_bar_minor_length_diff` | 0.35 | 其余刻度线的长度差值递减量 |
| `scale_bar_width` | 0.4 | 刻度线宽度 |
| `scale_bar_height` | 0.4 | 刻度线高度 |
| `scale_font_distance` | 0.3 | 刻度线与刻度值文本间距 |
| `scale_font_size` | 4.9 | 刻度值文本字号（毫米） |
| `scale_font_type` | "Arial" | 刻度值文本字体 |

### 刀片参数

| 参数名 | 默认值 | 说明 |
|--------|--------|------|
| `blade_length` | 39 | 刀片长度 |
| `blade_width` | 19.4 | 刀片宽度 |
| `blade_thickness` | 0.23 | 刀片厚度 |
| `hole_diameter` | 2.1 | 刀片孔径 |
| `hole_edge_distance` | 7 | 刀片孔中心到刀刃距离 |
| `side_notch_width` | 2.9 | 刀片侧面缺口宽度 |
| `side_notch_length` | 3.8 | 刀片侧面缺口长度 |
| `side_notch_edge_distance` | 9.6 | 刀片侧面缺口中心到刀刃距离 |
| `back_clamp_thickness` | 0.2 | 刀片背夹厚度 |
| `back_clamp_width` | 7 | 刀片背夹宽度 |

### 刀片夹具参数

| 参数名 | 默认值 | 说明 |
|--------|--------|------|
| `blade_protrusion_length` | 2 | 刀片从夹具中突出的长度 |
| `side_notch_height` | 2 | 刀片侧面缺口卡座高度 |

### 顶部刀片夹具参数

| 参数名 | 默认值 | 说明 |
|--------|--------|------|
| `upper_blade_holder_slider_size` | 4.7 | 顶部刀片夹具滑块尺寸 |
| `upper_blade_holder_slider_length` | 10 | 顶部刀片夹具滑块长度 |
| `upper_blade_holder_slider_spacing` | 24 | 两滑块中心间距 |
| `upper_blade_clamp_screw_countersink_diameter` | 4.2 | 顶部刀片夹片螺孔沉头直径 |
| `upper_blade_clamp_screw_countersink_height` | 1.2 | 顶部刀片夹片螺孔沉头高度 |

### 弹簧参数

| 参数名 | 默认值 | 说明 |
|--------|--------|------|
| `spring_seat_diameter` | 3.9 | 弹簧座直径 |
| `spring_seat_height` | 4 | 弹簧座高度 |

### 墙参数

| 参数名 | 默认值 | 说明 |
|--------|--------|------|
| `wall_length` | 20 | 墙长度 |
| `wall_thickness` | 15 | 墙厚度 |
| `wall_holder_distance` | 3 | 墙与夹具间距 |
| `wall_screw_center_side_distance` | 5 | 墙上螺丝孔中心到墙边距离 |
| `wall_screw_x_positions` | [28] | 墙上多组螺丝孔 x 坐标 |
| `wall_screw_type` | "M5,10" | 墙上螺丝孔类型（型号, 深度） |
| `wall_tongue_center_back_distance` | 4 | 墙公凸中心到后墙距离 |
| `wall_tongue_x_positions` | [15, 42.5] | 墙上多组公凸 x 坐标 |
| `wall_tongue_height` | 2.5 | 墙公凸高度 |
| `wall_tongue_diameter` | 3.5 | 墙公凸直径 |
| `wall_skirt_thickness` | 6 | 墙前档板厚度 |

### 手柄参数

| 参数名 | 默认值 | 说明 |
|--------|--------|------|
| `handle_axis_x_position` | 20 | 手柄转轴中心 x 坐标 |
| `handle_axis_z_position` | 39 | 手柄转轴中心 z 坐标 |
| `handle_axis_diameter` | 10 | 手柄转轴直径 |
| `handle_axis_length` | 30 | 手柄转轴长度 |
| `handle_axis_chamfer` | 1 | 手柄转轴倒角 |
| `handle_axis_to_end_distance` | 60 | 手柄轴心到末端水平距离 |
| `handle_axis_to_top_distance` | 12 | 手柄轴心到顶部边缘垂直距离 |
| `handle_thickness` | 8 | 手柄厚度 |
| `handle_chamfer` | 0.8 | 手柄倒角 |
| `handle_hole_wall_thickness` | 2 | 手柄孔壁厚 |

### 顶盖参数

| 参数名 | 默认值 | 说明 |
|--------|--------|------|
| `lid_height` | 5 | 顶盖高度（应大于 `wall_tongue_height`） |
| `lid_screw_slot_head_depth` | 3 | 顶盖螺丝顶孔深度 |
| `lid_screw_slot_head_diameter` | 8 | 顶盖螺丝顶孔直径 |
| `lid_screw_slot_diameter` | 5.2 | 顶盖螺丝孔直径 |
| `lid_back_thickness` | 0 | 顶盖后部厚度 |
| `lid_chamfer` | 0.6 | 顶盖倒角 |

### 哨片座参数

| 参数名 | 默认值 | 说明 |
|--------|--------|------|
| `reed_holder_length` | 40 | 哨片座长度 |
| `reed_holder_height` | 16 | 哨片座高度 |
| `reed_holder_fillet` | 0.4 | 哨片座圆角半径 |
| `staple_slot_length` | 23 | 哨座槽长度 |
| `staple_slot_diameter` | 6.8 | 哨座槽直径 |
| `reed_holder_notch_depth` | 0.4 | 哨片座刻痕深度 |
| `reed_holder_notch_height` | 3 | 哨片座刻痕高度 |
| `reed_holder_screw_type` | "M10" | 哨片座螺孔类型 |
| `reed_holder_screw_x_position` | 30 | 哨片座螺孔 x 坐标 |
| `mandrel_slot_depth` | 3.5 | 哨片锥槽深度 |
| `mandrel_slot_diameter` | 7.1 | 哨片锥槽直径 |
| `mandrel_diameter` | 4.5 | 哨片锥直径 |
| `tightening_screw_head_diameter` | 13 | 固定螺丝头部宽度 |
| `tightening_screw_head_height` | 8 | 固定螺丝头部高度 |
| `tightening_screw_height` | 18 | 固定螺丝高度 |

---

## 3D 打印建议

- **刀片夹具、刀片夹片、哨片座**建议使用 ≤ 0.12mm 层高以保证精度
- **刀片夹具**和**哨片座**需要打印支撑
- 如有条件，使用多色打印可使刻度标记更清晰
- 推荐使用 **PETG** 材料以获得更好的耐久性

---

## 项目结构

```
├── README.md              # 本文件
├── render.py              # STL 渲染脚本
├── draft.scad / draft2.scad  # 草稿文件
├── libs/
│   ├── obeh/              # Oboe / English Horn 版本
│   │   ├── params.scad    # 所有参数定义
│   │   ├── assembly.scad  # 装配体
│   │   └── modules/       # 各零件模块
│   │       ├── body.scad
│   │       ├── blade.scad
│   │       ├── blade_holder.scad
│   │       ├── handle.scad
│   │       ├── lid.scad
│   │       └── reed_holder.scad
│   └── utils/
│       └── utils.scad     # 工具模块
├── 3D_files/
│   └── obeh/
│       └── reed-guillotine.3mf  # 预生成文件
└── assets/                # 资源文件
```

---

## 许可

本项目基于 MIT 许可证开源。