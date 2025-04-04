#!/usr/bin/env bash

window_pid=$(yabai -m query --windows --window | jq -r '.pid') 
app_name=$(yabai -m query --windows --window | jq -r '.app')
count_pid=$(yabai -m query --windows | jq "[.[] | select(.pid == ${window_pid})] | length")
if [ "$count_pid" -gt 1 ]; then
	yabai -m window --close
else
    osascript -e "tell application \"${app_name}\" to quit"
fi
