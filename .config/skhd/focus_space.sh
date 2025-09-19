#!/usr/bin/env bash

# Switch focus to an id of a space on the current display
# If the space does not exist, do nothing
# Usage: focus_space.sh <space_id>

id="$1"

base="$(yabai -m query --displays --display | jq -r .spaces[0])"
space_idx="$((id + base - 1))"

num_spaces="$(yabai -m query --spaces | jq -r length)"
if (( id > num_spaces )); then
    for (( i = num_spaces + 1; i < id; i++ )); do
        yabai -m space --create
    done
fi

yabai -m space --focus "$space_idx"
