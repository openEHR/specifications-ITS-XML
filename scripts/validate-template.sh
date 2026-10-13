#!/bin/sh
# Validate an XML instance (typically an OPT 1.4) against an XSD with xmllint.
# Usage: validate-template.sh INSTANCE_XML [SCHEMA_XSD]
# SCHEMA_XSD defaults to components/AM/Release-1.4/Template.xsd. Exit status: 0 valid, 3 invalid (the
# xmllint code), 2 usage or missing file, 127 xmllint not installed.

set -eu

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)

if [ "$#" -lt 1 ] || [ "$#" -gt 2 ]; then
    printf 'Usage: %s INSTANCE_XML [SCHEMA_XSD]\n' "$0" >&2
    exit 2
fi

if ! command -v xmllint >/dev/null 2>&1; then
    printf '%s: xmllint not found (on Debian/Ubuntu: apt install libxml2-utils)\n' "$0" >&2
    exit 127
fi

instance=$1
schema_path=${2:-"$script_dir/../components/AM/Release-1.4/Template.xsd"}

for file in "$instance" "$schema_path"; do
    if [ ! -f "$file" ]; then
        printf '%s: no such file: %s\n' "$0" "$file" >&2
        exit 2
    fi
done

# a path starting with '-' must not be read as an xmllint option
case $instance in -*) instance=./$instance ;; esac
case $schema_path in -*) schema_path=./$schema_path ;; esac

xmllint --noout --schema "$schema_path" "$instance"
