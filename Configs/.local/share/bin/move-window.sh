#!/usr/bin/env sh

RESIZE_SIZE=${1:?Missing resize size}
DIRECTION=${2:?Missing move direction}

# Validate RESIZE_SIZE is a number
if ! [ "$RESIZE_SIZE" -eq "$RESIZE_SIZE" ] 2>/dev/null; then
    echo "Invalid resize size: $RESIZE_SIZE. It must be a number."
    exit 1
fi

# Set resize parameters based on direction
case "$DIRECTION" in
l)
    RESIZE_PARAMS_X=-$RESIZE_SIZE
    RESIZE_PARAMS_Y=0
    ;;
r)
    RESIZE_PARAMS_X=$RESIZE_SIZE
    RESIZE_PARAMS_Y=0
    ;;
u)
    RESIZE_PARAMS_X=0
    RESIZE_PARAMS_Y=-$RESIZE_SIZE
    ;;
d)
    RESIZE_PARAMS_X=0
    RESIZE_PARAMS_Y=$RESIZE_SIZE
    ;;
*)
    echo "Invalid direction: $DIRECTION. Use l, r, u, or d."
    exit 1
    ;;
esac

# Get the active window and check if it's floating
ACTIVE_WINDOW=$(hyprctl activewindow -j)
IS_FLOATING=$(echo "$ACTIVE_WINDOW" | jq -r .floating)

if [ "$IS_FLOATING" = "true" ]; then
    hyprctl dispatch moveactive "$RESIZE_PARAMS_X" "$RESIZE_PARAMS_Y"
else
    hyprctl dispatch movewindow "$DIRECTION"
fi
