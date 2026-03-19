#!/bin/sh

set -eu

check() {
    description="$1"
    shift

    if "$@"; then
        echo "PASS: ${description}"
    else
        echo "FAIL: ${description}"
        exit 1
    fi
}

check_output_contains() {
    description="$1"
    expected="$2"
    shift 2

    output="$("$@")"
    case "$output" in
        *"$expected"*)
            echo "PASS: ${description}"
            ;;
        *)
            echo "FAIL: ${description}"
            echo "Output was: ${output}"
            exit 1
            ;;
    esac
}

check "curl is available via common-utils" command -v curl
check "databricks is installed" command -v databricks
check "databricks binary is executable" test -x /usr/local/bin/databricks
check_output_contains "databricks reports a version" "Databricks CLI" databricks -v
