#!/usr/bin/env bash

# Send the current window to the same space on a different display
# Usage: send_to_display.sh <display_number>

display_id="$1"

# Calculate the current space index (1-based)
curr_base="$(yabai -m query --displays --display | jq -r '.spaces[0]')"
curr_idx="$(yabai -m query --spaces --space | jq -r '.index')"
idx=$((curr_idx - curr_base + 1))

# Calculate the target space index on the specified display
target_base="$(yabai -m query --displays --display "$display_id" | jq -r '.spaces[0]')"
target_idx=$((target_base + idx - 1))
num_spaces="$(yabai -m query --spaces --display "$display_id" | jq -r 'length')"
if (( target_idx > num_spaces )); then
    for (( i = num_spaces + 1; i < target_idx; i++ )); do
        yabai -m space --create "$display_id"
    done
fi

# Move the current window to the target space and switch to that space
yabai -m window --space "$target_idx"
yabai -m display --focus "$display_id"
