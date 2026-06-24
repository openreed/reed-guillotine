# Reed Guillotine

[Read in English](README.md) | [[以中文阅读](README_CN.md)]

> OpenSCAD parametric model source for the OpenReed reed guillotine.
> For product info, visit the [project page](https://openreed.github.io/oboe/reed-guillotine/).

---

## Table of Contents

- [Reed Guillotine](#reed-guillotine)
  - [Table of Contents](#table-of-contents)
  - [Generating 3D Model Files](#generating-3d-model-files)
    - [Prerequisites](#prerequisites)
    - [Using the Render Script](#using-the-render-script)
    - [Pre-generated Files](#pre-generated-files)
  - [Parameter Reference](#parameter-reference)
  - [3D Printing Tips](#3d-printing-tips)
  - [Project Structure](#project-structure)
  - [License](#license)

---

## Generating 3D Model Files

### Prerequisites

- [OpenSCAD](https://openscad.org/) (recommended: `brew install openscad` on macOS)
- Python 3
- [BOSL2](https://github.com/revarbat/BOSL2) library — install via OpenSCAD's Library Manager

### Using the Render Script

The project provides `render.py` to render all parts to STL in one command:

```bash
# Render all parts of the oboe/English horn version
python render.py obeh

# Render only specific parts (comma-separated)
python render.py obeh --parts body,lid,handle

# Render assembly only
python render.py obeh --assembly-only

# Custom output directory
python render.py obeh --output ./my_stls

# List available model versions
python render.py --list-versions
```

STL files are saved to `3D_files/obeh/` by default.

### Pre-generated Files

Pre-generated `.3mf` files are also available for direct download from MakerWorld.

---

## Parameter Reference

All parameters are defined in `libs/obeh/params.scad`. See the [Chinese README](README_CN.md#参数说明) for the complete parameter table with descriptions.

The parameters are organized into the following groups:

| Group | Description |
|-------|-------------|
| Tolerances | Fine-tune part fit and assembly clearance |
| Base Parameters | Main body dimensions and fillets |
| Slot Parameters | Reed holder slot geometry |
| Scale Parameters | Cutting scale markings |
| Blade Parameters | Standard utility blade (009 RD) dimensions |
| Blade Holder Parameters | Blade clamp geometry |
| Upper Blade Holder Parameters | Upper blade holder slider and screw dimensions |
| Spring Parameters | Spring seat dimensions |
| Wall Parameters | Side walls and screw holes |
| Handle Parameters | Handle and axle geometry |
| Lid Parameters | Top lid dimensions |
| Reed Holder Parameters | Reed holder, staple slot, and mandrel dimensions |

---

## 3D Printing Tips

- Use ≤ 0.12 mm layer height for the blade holder, blade clamps, and reed holder
- Enable supports for the blade holder and reed holder
- Multi-color printing makes scale markings more readable
- **PETG** is recommended for better durability

---

## Project Structure

```
├── README.md              # This file
├── render.py              # STL rendering script
├── draft.scad / draft2.scad  # Scratch files
├── libs/
│   ├── obeh/              # Oboe / English Horn version
│   │   ├── params.scad    # All parameter definitions
│   │   ├── assembly.scad  # Assembly model
│   │   └── modules/       # Individual part modules
│   │       ├── body.scad
│   │       ├── blade.scad
│   │       ├── blade_holder.scad
│   │       ├── handle.scad
│   │       ├── lid.scad
│   │       └── reed_holder.scad
│   └── utils/
│       └── utils.scad     # Utility module
├── 3D_files/
│   └── obeh/
│       └── reed-guillotine.3mf  # Pre-generated file
└── assets/                # Assets
```

---

## License

MIT License — © 2026 OpenReed Project
