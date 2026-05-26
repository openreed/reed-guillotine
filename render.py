#!/usr/bin/env python3
"""
OpenSCAD model rendering script.
Renders .scad files to STL, organized by model version.

Usage:
    python render.py obeh                     # Render all parts of the oboe/English horn version
    python render.py obeh --parts body,lid    # Render only specified parts
    python render.py obeh --assembly-only     # Render assembly only
    python render.py --list-versions          # List available versions
    python render.py obeh --output ./my_stls  # Specify output directory
"""

import argparse
import subprocess
import sys
from pathlib import Path

PROJECT_ROOT = Path(__file__).resolve().parent
LIBS_DIR = PROJECT_ROOT / "libs"


# ── Version Configuration ─────────────────────────────────
# Each version corresponds to a directory ./libs/<version>/
# key:   version name (also the directory name)
# value: {
#   "name":   Display name
#   "parts":  List of individually renderable parts
#             (name, source file relative path) — these files have top-level geometry calls
# }

VERSIONS = {
    "obeh": {
        "name": "Oboe / English Horn Reed Guillotine",
        "assembly": "assembly.scad",
        "parts": [
            ("body",         "modules/body.scad"),
            ("blade",        "modules/blade.scad"),
            ("blade_holder", "modules/blade_holder.scad"),
            ("handle",       "modules/handle.scad"),
            ("lid",          "modules/lid.scad"),
            ("reed_holder",  "modules/reed_holder.scad"),
        ],
    },
    # Future versions can be added here, e.g.:
    # "bsn": {
    #     "name": "Bassoon Reed Guillotine",
    #     "assembly": "assembly.scad",
    #     "parts": [
    #         ("body", "modules/body.scad"),
    #         ...
    #     ],
    # },
}


# ── Utility Functions ─────────────────────────────────────

def find_openscad() -> str:
    """Find the openscad executable on the system"""
    candidates = [
        "openscad",
        "/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD",
        "/usr/local/bin/openscad",
        "/opt/homebrew/bin/openscad",
    ]
    for cmd in candidates:
        try:
            subprocess.run([cmd, "--version"], capture_output=True, check=False)
            return cmd
        except FileNotFoundError:
            continue
    raise FileNotFoundError(
        "OpenSCAD not found. Please install it first:\n"
        "  - macOS: brew install openscad\n"
        "  - Or download from https://openscad.org/"
    )


def render_file(openscad_cmd: str, scad_path: Path, output_path: Path, label: str) -> bool:
    """Render a single .scad file to STL"""
    output_path.parent.mkdir(parents=True, exist_ok=True)
    if output_path.exists():
        output_path.unlink()

    print(f"  ⏳ Rendering [{label}] ...", end=" ", flush=True)
    result = subprocess.run(
        [openscad_cmd, "-o", str(output_path), "--export-format", "binstl", str(scad_path)],
        capture_output=True, text=True, timeout=600,
    )

    if result.returncode == 0 and output_path.exists():
        size_kb = output_path.stat().st_size / 1024
        rel = output_path.relative_to(PROJECT_ROOT)
        print(f"✅ {size_kb:.1f} KB → {rel}")
        return True
    else:
        print(f"❌ Failed (return code={result.returncode})")
        if result.stderr.strip():
            for line in result.stderr.strip().splitlines()[-5:]:
                print(f"     {line}")
        return False


def list_versions() -> list:
    """Scan libs/ directory and return list of available versions"""
    available = []
    if not LIBS_DIR.exists():
        return available
    for d in sorted(LIBS_DIR.iterdir()):
        if d.is_dir() and d.name != "utils" and (d / "assembly.scad").exists():
            available.append(d.name)
    return available


def get_version_dir(version: str) -> Path:
    return LIBS_DIR / version


# ── Main ──────────────────────────────────────────────────

def main():
    parser = argparse.ArgumentParser(
        description="Render OpenSCAD models to STL files (organized by model version)",
        formatter_class=argparse.RawDescriptionHelpFormatter,
    )
    parser.add_argument(
        "version",
        nargs="?",
        type=str,
        default=None,
        help="Model version, e.g. obeh, bsn, etc.",
    )
    parser.add_argument(
        "--output", "-o",
        type=str,
        default=None,
        help="STL output directory (default: ./3D_files/<version>/)",
    )
    parser.add_argument(
        "--parts", "-p",
        type=str,
        default=None,
        help="Only render specified parts, comma-separated (default: all)",
    )
    parser.add_argument(
        "--assembly-only", "-a",
        action="store_true",
        help="Render assembly only (assembly.scad), skip individual parts",
    )
    parser.add_argument(
        "--list-versions",
        action="store_true",
        help="List all available model versions",
    )

    args = parser.parse_args()

    # ── List Versions ──
    if args.list_versions:
        avail = list_versions()
        print("Available model versions:")
        for v in avail:
            info = VERSIONS.get(v, {})
            name = info.get("name", v)
            print(f"  {v:12s} — {name}")
        if not avail:
            print("  (No valid model versions found in libs/)")
        return

    # ── Validate Version ──
    if not args.version:
        parser.print_help()
        print("\nPlease specify a model version. Available versions:")
        for v in list_versions():
            info = VERSIONS.get(v, {})
            name = info.get("name", v)
            print(f"  {v:12s} — {name}")
        sys.exit(1)

    version = args.version
    if version not in VERSIONS:
        # Not in predefined list, try loading from libs/
        if not (LIBS_DIR / version / "assembly.scad").exists():
            avail = list_versions()
            print(f"Unknown model version: {version}")
            print(f"Available versions: {', '.join(avail)}")
            sys.exit(1)
        # Dynamically create config
        VERSIONS[version] = {
            "name": version,
            "assembly": "assembly.scad",
            "parts": [],
        }
        modules_dir = LIBS_DIR / version / "modules"
        if modules_dir.exists():
            for f in sorted(modules_dir.glob("*.scad")):
                part_name = f.stem
                VERSIONS[version]["parts"].append((part_name, f"modules/{part_name}.scad"))

    config = VERSIONS[version]
    version_dir = get_version_dir(version)

    if not version_dir.exists():
        print(f"Directory not found: {version_dir}")
        sys.exit(1)

    # ── Find OpenSCAD ──
    try:
        openscad_cmd = find_openscad()
        print(f"🔧 Using OpenSCAD: {openscad_cmd}")
    except FileNotFoundError as e:
        print(e, file=sys.stderr)
        sys.exit(1)

    # ── Output Directory ──
    output_dir = Path(args.output).resolve() if args.output else (PROJECT_ROOT / "3D_files" / version)
    output_dir.mkdir(parents=True, exist_ok=True)
    print(f"📁 Model version: {version} — {config['name']}")
    print(f"📁 Output directory: {output_dir}")
    print()

    # ── Collect Render Tasks ──
    tasks = []  # (label, scad_path, output_stl_path)

    if args.parts:
        # User-specified parts
        selected = [p.strip() for p in args.parts.split(",")]
        for name in selected:
            if name == "assembly":
                scad = version_dir / config["assembly"]
                out = output_dir / "assembly.stl"
                tasks.append((f"{version}/assembly", scad, out))
            else:
                found = False
                for pname, prel in config["parts"]:
                    if pname == name:
                        scad = version_dir / prel
                        out = output_dir / f"{pname}.stl"
                        tasks.append((f"{version}/{pname}", scad, out))
                        found = True
                        break
                if not found:
                    print(f"  ⚠️  Skipping [{name}]: unknown part (available: assembly, {', '.join(p for p, _ in config['parts'])})")
    else:
        # Assembly
        scad = version_dir / config["assembly"]
        out = output_dir / "assembly.stl"
        tasks.append((f"{version}/assembly", scad, out))

        if not args.assembly_only:
            # Individual parts
            for pname, prel in config["parts"]:
                scad = version_dir / prel
                out = output_dir / f"{pname}.stl"
                tasks.append((f"{version}/{pname}", scad, out))

    if not tasks:
        print("No files to render.")
        sys.exit(0)

    # ── Check source files exist ──
    tasks = [(l, s, o) for l, s, o in tasks if s.exists()]
    if not tasks:
        print("All specified source files do not exist.")
        sys.exit(1)

    print(f"📋 {len(tasks)} render task(s):\n")

    successes = 0
    failures = 0
    for idx, (label, scad_path, out_path) in enumerate(tasks, 1):
        print(f"[{idx}/{len(tasks)}] ", end="")
        ok = render_file(openscad_cmd, scad_path, out_path, label)
        if ok:
            successes += 1
        else:
            failures += 1

    # ── Summary ──
    print()
    print("=" * 50)
    print(f"Rendering complete: ✅ {successes} succeeded, ❌ {failures} failed")
    print(f"STL files saved in: {output_dir}")
    print("=" * 50)

    return 0 if failures == 0 else 1


if __name__ == "__main__":
    sys.exit(main())
