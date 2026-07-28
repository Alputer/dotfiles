#!/usr/bin/env bash
# Open default apps and place them on their workspaces (startup only).

move_app_to_workspace() {
  local app="$1"
  local bundle_id="$2"
  local workspace="$3"

  open -a "$app"

  local wid=""
  for _ in $(seq 1 40); do
    wid=$(aerospace list-windows --monitor all --app-bundle-id "$bundle_id" --format '%{window-id}' 2>/dev/null | head -n1)
    if [[ -n "$wid" ]]; then
      while IFS= read -r window_id; do
        [[ -n "$window_id" ]] || continue
        aerospace move-node-to-workspace --window-id "$window_id" "$workspace"
      done < <(aerospace list-windows --monitor all --app-bundle-id "$bundle_id" --format '%{window-id}' 2>/dev/null)
      return 0
    fi
    sleep 0.25
  done
}

move_app_to_workspace "Brave Browser" "com.brave.Browser" "B"
move_app_to_workspace "Slack" "com.tinyspeck.slackmacgap" "S"
move_app_to_workspace "Cursor" "com.todesktop.230313mzl4w4u92" "C"
move_app_to_workspace "WezTerm" "com.github.wez.wezterm" "T"
