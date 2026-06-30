#!/usr/bin/env python3
"""
Build an all-in-one .scad file from a model version under libs/.

Given a version name like `obeh`, this script:
1. Reads params.scad, modules/*.scad, assembly.scad, and utils/utils.scad
2. Strips all `include <...>` and `use <...>` references
3. Extracts only module/function definitions from dependency files (no demo code)
4. Combines everything into a single `reed-guillotine-{name}.scad` file
   that only depends on the BOSL2 library (no other .scad files needed).

Usage:
    python build_all_in_one.py obeh
"""

import argparse
import os
import re
import sys
from pathlib import Path

PROJECT_ROOT = Path(__file__).resolve().parent
LIBS_DIR = PROJECT_ROOT / "libs"


def read_file(path: Path) -> str:
    with open(path, "r", encoding="utf-8") as f:
        return f.read()


def strip_include_use_lines(content: str) -> str:
    """Remove lines that are `include <...>` or `use <...>` statements."""
    lines = content.split("\n")
    filtered = [
        line
        for line in lines
        if not re.match(r"^\s*(include|use)\s*<", line.strip())
    ]
    return "\n".join(filtered)


def extract_module_and_function_defs(content: str) -> str:
    """
    Extract only `module X(...) { ... }` and `function X(...) = ...;`
    definitions from a .scad file.  Discards top-level instantiation calls,
    include/use lines, and other top-level code.
    """
    lines = content.split("\n")
    result_lines = []
    i = 0
    n = len(lines)

    while i < n:
        stripped = lines[i].strip()

        # --- module definition ---
        m = re.match(r"^module\s+(\w+)\s*\(", stripped)
        if m:
            # Collect the full module block (track brace depth)
            depth = 0
            started = False
            block_lines = []
            j = i
            while j < n:
                line = lines[j]
                block_lines.append(line)
                # Count braces in this line (ignoring comments is hard; 
                # approximate: count all { and })
                for ch in line:
                    if ch == "{":
                        depth += 1
                        started = True
                    elif ch == "}":
                        depth -= 1
                if started and depth == 0:
                    j += 1
                    break
                j += 1

            result_lines.extend(block_lines)
            result_lines.append("")  # blank line separator
            i = j
            continue

        # --- function definition ---
        m = re.match(r"^function\s+(\w+)\s*\(", stripped)
        if m:
            # Collect until the terminating semicolon
            block_lines = []
            j = i
            while j < n:
                line = lines[j]
                block_lines.append(line)
                if ";" in line:
                    j += 1
                    break
                j += 1

            result_lines.extend(block_lines)
            result_lines.append("")
            i = j
            continue

        i += 1

    return "\n".join(result_lines)


def extract_assembly_code(content: str) -> str:
    """
    From assembly.scad content, remove include/use lines but keep
    everything else (top-level translate/rotate/module-call code).
    """
    return strip_include_use_lines(content)


def build_all_in_one(model_dir: Path, output_path: Path) -> None:
    """
    Build the all-in-one .scad file.

    Args:
        model_dir: Path to the model directory (e.g., libs/obeh)
        output_path: Where to write the output file
    """
    utils_dir = LIBS_DIR / "utils"

    # --- 1. Determine which BOSL2 includes are needed ---
    # Check assembly.scad for BOSL2 references
    assembly_path = model_dir / "assembly.scad"
    assembly_raw = read_file(assembly_path)
    bosl2_includes = []
    for line in assembly_raw.split("\n"):
        stripped = line.strip()
        if re.match(r"^include\s*<BOSL2/", stripped):
            bosl2_includes.append(stripped)

    if not bosl2_includes:
        # Default: at least BOSL2/std.scad
        bosl2_includes = ["include <BOSL2/std.scad>"]

    # --- 2. Read params ---
    params_path = model_dir / "params.scad"
    params_content = read_file(params_path)

    # --- 3. Read utils ---
    utils_path = utils_dir / "utils.scad"
    utils_raw = read_file(utils_path)
    utils_defs = extract_module_and_function_defs(utils_raw)

    # --- 4. Read module files ---
    modules_dir = model_dir / "modules"
    module_files = sorted(modules_dir.glob("*.scad"))
    module_defs_parts = []
    for mf in module_files:
        raw = read_file(mf)
        defs = extract_module_and_function_defs(raw)
        if defs.strip():
            module_defs_parts.append(defs)

    # --- 5. Read assembly ---
    assembly_code = extract_assembly_code(assembly_raw)

    # --- 6. Assemble the output ---
    sections = []

    # Header comment
    model_name = model_dir.name
    sections.append("// ============================================================")
    sections.append(f"// All-in-one file for reed-guillotine-{model_name}")
    sections.append("// Auto-generated by build_all_in_one.py")
    sections.append("//")
    sections.append("// This file bundles all module definitions, parameters,")
    sections.append("// and assembly code into a single file.")
    sections.append("// External dependencies: BOSL2 library only.")
    sections.append("// ============================================================")
    sections.append("")

    # BOSL2 includes
    for inc in bosl2_includes:
        sections.append(inc)
    sections.append("")

    # Params
    sections.append("// ==================== PARAMETERS ====================")
    sections.append(params_content.strip())
    sections.append("")

    # Utils
    if utils_defs.strip():
        sections.append("// ==================== UTILITY FUNCTIONS ====================")
        sections.append(utils_defs.strip())
        sections.append("")

    # Modules
    for i, mf in enumerate(module_files):
        sections.append(f"// ==================== MODULE: {mf.stem} ====================")
        sections.append(module_defs_parts[i].strip())
        sections.append("")

    # Assembly
    sections.append("// ==================== ASSEMBLY ====================")
    sections.append(assembly_code.strip())
    sections.append("")

    output_content = "\n".join(sections)

    # Write output
    output_path.parent.mkdir(parents=True, exist_ok=True)
    with open(output_path, "w", encoding="utf-8") as f:
        f.write(output_content)

    print(f"✅ All-in-one file written to: {output_path}")
    print(f"   Includes: BOSL2 + params + {len(module_files)} modules + utils + assembly")


def main():
    parser = argparse.ArgumentParser(
        description="Build an all-in-one .scad file from a model version under libs/."
    )
    parser.add_argument(
        "version",
        help="Version name, e.g., obeh (corresponds to libs/obeh/)",
    )
    args = parser.parse_args()

    model_dir = LIBS_DIR / args.version
    if not model_dir.is_dir():
        print(f"Error: '{model_dir}' is not a valid directory.", file=sys.stderr)
        print(f"Available versions: {[d.name for d in sorted(LIBS_DIR.iterdir()) if d.is_dir() and d.name != 'utils']}", file=sys.stderr)
        sys.exit(1)

    # Check required files
    required = ["params.scad", "assembly.scad"]
    for fname in required:
        if not (model_dir / fname).is_file():
            print(f"Error: '{fname}' not found in '{model_dir}'.", file=sys.stderr)
            sys.exit(1)

    modules_dir = model_dir / "modules"
    if not modules_dir.is_dir():
        print(f"Error: 'modules/' not found in '{model_dir}'.", file=sys.stderr)
        sys.exit(1)

    model_name = model_dir.name
    output_path = model_dir / f"reed-guillotine-{model_name}.scad"

    build_all_in_one(model_dir, output_path)


if __name__ == "__main__":
    main()
