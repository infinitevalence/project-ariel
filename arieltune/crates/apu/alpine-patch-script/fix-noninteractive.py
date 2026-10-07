#!/usr/bin/env python3
"""Fix bc250-enable-40cu-alpine.sh: add non-interactive --patches support."""

path = "bc250-enable-40cu-alpine.sh"

with open(path, "r") as f:
    lines = f.readlines()

# The interactive block: lines 165-234 (1-based) = idx 164-233
# idx 163 = line 164 = "selected_patches=\"\""  -- keep
# idx 164 = line 165 = "\n"                      -- start replacing here
# idx 233 = line 234 = "\tdone\n"                -- end REPLACING here
# idx 234 = line 235 = "\n"                      -- keep (blank before "# Apply")

interact_start = 164   # idx of empty line after selected_patches=""
interact_end = 234     # idx of line after "done" (exclusive)

interactive_lines = [line for line in lines[interact_start:interact_end]]

# Build replacement text
# We add an if-block for non-interactive mode at the top
# The interactive block (after else) needs one extra tab indent

# Collect non-interactive block
non_interactive = [
        "\tif [ -n \"$OPT_PATCHES\" ]; then\n",
        "\t\t# Non-interactive: pick patch numbers from --patches comma list\n",
        "\t\tfor pnum in $sorted_nums; do\n",
        "\t\t\t# Match patch number; need spaces around it for grep -qw\n",
        "\t\t\tif echo \" $OPT_PATCHES \" | grep -qw \" $pnum \"; then\n",
        '\t\t\t\tselected_patches="${selected_patches} ${pnum}"\n',
        "\t\t\tfi\n",
        "\t\tdone\n",
        '\t\tinfo "Non-interactive mode: patches $(echo $selected_patches | tr -s \\' \\')"\n',
        "\t#else\n",
]

# Add the interactive block with each line getting ONE extra tab
# Lines that start with "\t\t" (double-tabbed) become "\t\t\t" (triple)
# But we need to keep the original indentation relative
for line in interactive_lines:
    # Just prepend one tab to every line inside the else branch
    # since they're already correctly indented one level deeper inside the for
    non_interactive.append("\t" + line if not line.startswith("") else "\n")

# Add the closing fi
non_interactive.append("\t\t\n", "\tfi\n", "\n")

# Build result
new_lines = lines[:interact_start] + non_interactive + lines[interact_end:]

# Now fix the --patches arg parsing (line 401-407 / idx 400-406)
# The issue: "--patches) OPT_PATCHES="${2:-}" ;; doesn't work because
# ${2:-} is always the 2nd positional arg, not "the next one after --patches"
# Fix: use a shift-based approach or loop index

for i in range(400, 410):
    if 'for _arg in "$@"' in new_lines[i]:
        print(f"Found arg parsing at idx={i}, line={i+1}")
        # Replace lines idx 400 through 406
        new_arg = [
            "\n",
            "# Parse extra flags from args\n",
            "OPT_PATCHES=\"\n",
            '_i=1\n',  # start after script name (shifted)
            'for _arg in "$@"; do\n',
            "\tcase \"$_arg\" in\n",
        "\t\t--verbose|-v) VERBOSE=1 ;;\n",
            '\t\t--patches) OPT_PATCHES="${!((_i+1))}"; ((i++)) ;;\n',
            "\t\tesac\n",
            '\t(( i++ )) || true\n',
            "done\n",
        ]
        new_lines[400:407] = new_arg
        print("Replaced arg parsing")
        break

with open(path, "w") as f:
    f.writelines(new_lines)

print("Done. Patch selection now supports --patches \"1,2,3\"")
