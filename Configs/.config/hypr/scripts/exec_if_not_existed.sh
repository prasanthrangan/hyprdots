workspaceId=$(hyprctl monitors | grep 'active workspace' | grep -oP '\d+' | sed -n 1p)
exitWindows=$(hyprctl -j clients | jq --arg id "$workspaceId" '.[] | select(.workspace.id == ($id | tonumber))')

echo $exitWindows

if [ -z "$exitWindows" ]; then
  $1
fi
