#!/usr/bin/env bash

# This script moves the currently focused window to a specified workspace.
# Usage: ./move_window.sh <workspace_number>

id="$1"

base="$(yabai -m query --displays --display | jq -r .spaces[0])"
space_idx="$((base + id - 1))"

num_spaces="$(yabai -m query --spaces | jq -r length)"
if (( id > num_spaces )); then
    for (( i = num_spaces + 1; i < id; i++ )); do
        yabai -m space --create
    done
fi

target="$(yabai -m query --windows --window | jq -r .id)"
yabai -m window --space "$space_idx"
yabai -m space --focus "$space_idx"
yabai -m window --focus "$target"
