#!/bin/sh
# Check the OPT 1.4 examples against components/AM/Release-1.4/Template.xsd with xmllint:
#   examples/AOM1/operational/*.opt          must validate
#   examples/AOM1/operational/invalid/*.opt  must be rejected (each has one deliberate defect)
# Usage: validate-examples.sh
# Exit status: 0 if every example behaves as expected, 1 if not, 127 if xmllint is not installed.

set -u

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
repo=$(CDPATH= cd -- "$script_dir/.." && pwd)
schema=$repo/components/AM/Release-1.4/Template.xsd
examples=$repo/examples/AOM1/operational

if ! command -v xmllint >/dev/null 2>&1; then
    printf '%s: xmllint not found (on Debian/Ubuntu: apt install libxml2-utils)\n' "$0" >&2
    exit 127
fi

status=0

for file in "$examples"/*.opt; do
    [ -e "$file" ] || continue
    if xmllint --noout --schema "$schema" "$file" >/dev/null 2>&1; then
        printf 'ok    valid     %s\n' "${file#"$repo"/}"
    else
        printf 'FAIL  rejected, but expected valid:     %s\n' "${file#"$repo"/}"
        status=1
    fi
done

for file in "$examples"/invalid/*.opt; do
    [ -e "$file" ] || continue
    if xmllint --noout --schema "$schema" "$file" >/dev/null 2>&1; then
        printf 'FAIL  accepted, but expected invalid:   %s\n' "${file#"$repo"/}"
        status=1
    else
        printf 'ok    invalid   %s\n' "${file#"$repo"/}"
    fi
done

exit "$status"
