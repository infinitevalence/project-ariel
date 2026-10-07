#!/usr/bin/env bash
# test-permutations.sh - test all 128 patch combinations non-interactively
#
# Usage:
#   ./test-perms.sh                 # extended mode (4 key combos)
#   ./test-perms.sh --full          # all 128 permutations (very slow)
#   ./test-perms.sh --list          # show patch list
#   ./test-perms.sh --patches "12,28"
#
set -euo pipefail

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SCRIPT="$SCRIPT_DIR/bc250-enable-40cu-alpine.sh"
PATCHBASE="$SCRIPT_DIR/../patches"
OPT_IN='12 17 19 21 28 29 30'
PASS=0
FAIL=0

GREEN=$'\033[0;32m'
RED=$'\033[0;31m'
NC=$'\033[0m'

pass() { printf "${GREEN}  PASS  %s${NC}\n" "$1"; PASS=$((PASS + 1)); }
fail() { printf "${RED}  FAIL  %s${NC}\n" "$1"; FAIL=$((FAIL + 1)); }

discover_all_patches() {
	local d="$PATCHBASE/alpine-6.18.53"
	[ -d "$d" ] || exit 1
	for f in "$d"/*.patch; do
		basename "$f" .patch | cut -d'-' -f1
	done | sort -n
}

run_one() {
	local label="$1" shift
	local patch_arg="${*:-}"
	# Remove leading/trailing whitespace
	patch_arg="$(echo "$patch_arg" | sed 's/^ *//' | sed 's/ *$//')"
	
	if [ -z "$patch_arg" ]; then
		# Defaults only
		if bash "$SCRIPT" build > /dev/null 2>&1; then
			pass "$label"
			return 0
		else
			fail "$label"
			return 1
		fi
	else
		if bash "$SCRIPT" build --patches "$patch_arg" > /dev/null 2>&1; then
			pass "$label"
			return 0
		else
			fail "$label"
			return 1
		fi
	fi
}

# Extended: test 4 key configurations
run_extended() {
	echo "=== Extended mode: 4 key configurations ==="
	echo ""
	
	# 1. Defaults only
	run_one "defaults-only"
	
	# 2. Defaults + patch 28 (the reported failure)
	run_one "defaults+28" "28"
	
	# 3. Defaults + 28 + 29
	run_one "defaults+28+29" "28,29"
	
	# 4. All opt-in patches
	run_one "all-opt-in" "12,17,19,21,28,29,30"
}

# Full: all 2^7 combinations (very slow)
run_full() {
	echo "=== Full mode: 128 permutations ==="
	echo ""
	
	# Convert space-separated to array
	opts=($OPT_IN)
	n_opts=7
	
	for mask in $(seq 0 127); do
		patches=""
		for i in $(seq 0 6); do
			# Check bit i
			if (( (mask >> i) & 1 )); then
				patches="${patches}${opts[$i]},"
			fi
		done
		patches="${patches%,}"  # remove trailing comma
		
		label="mask_${mask}"
		[ -z "$patches" ] && label="mask_${mask}_defaults"
		
		if [ -z "$patches" ]; then
			run_one "$label"
		else
			run_one "$label" "$patches"
		fi
	done
}

if [ "${1:-}" = "--list" ]; then
	echo "All patches:"
	discover_all_patches | sed 'n;=;l' | paste - -| tail
	echo "Opt-in (y/N prompt): $OPT_IN"
	echo ""
	discover_all_patches
	exit 0
fi

if [ "${1:-}" = "--full" ]; then
	run_full
elif [ "${1:-}" = "--patches" ]; then
	[ -z "${2:-}" ] && { echo "Usage: $0 --patches \"12,28\""; exit 1; }
	echo "=== Running with patches: $2 ==="
	run_one "custom" "$2"
else
	run_extended
fi

echo ""
echo "--- Total: $PASS passed, $FAIL failed ---"
[ "$FAIL" -gt 0 ] && exit 1
