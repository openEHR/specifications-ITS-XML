#!/bin/sh

set -eu

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
schema_path=${2:-"$script_dir/../components/AM/Release-1.4/Template.xsd"}

if [ "$#" -lt 1 ] || [ "$#" -gt 2 ]; then
    printf 'Usage: %s INSTANCE_XML [SCHEMA_XSD]\n' "$0" >&2
    exit 2
fi

xmllint --noout --schema "$schema_path" "$1"