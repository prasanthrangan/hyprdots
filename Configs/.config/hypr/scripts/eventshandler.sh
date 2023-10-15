#!/bin/sh

run=$HOME/Scripts/


# default handlers for shellevents
#
# override the function in your own events
# file to provide a custom handler
#
# comments inside each handler list the variables
# that are set when the handler is invoked

event_workspace() {
  : # WORKSPACENAME
}

event_focusedmon() {
  : # MONNAME WORKSPACENAME
}

event_activewindow() {
  : # WINDOWCLASS WINDOWTITLE
}

event_fullscreen() {
  : # ENTER (0 if leaving fullscreen, 1 if entering)
}

event_monitorremoved() {
  : # MONITORNAME
 $HOME/Scripts/Monitor_Set
    notify-send "Event Monitor Removed"

}

event_monitoradded() {
  : # MONITORNAME
   $HOME/Scripts/Monitor_Set
  notify-send "Event Monitor Added"
}

event_createworkspace() {
  : # WORKSPACENAME
}

event_destroyworkspace() {
  : # WORKSPACENAME
}

event_moveworkspace() {
  : # WORKSPACENAME MONNAME
}

event_activelayout() {
  : # KEYBOARDNAME LAYOUTNAME
  #notify-send "$KEYBOARDNAME $LAYOUTNAME"
	
}

event_openwindow() {
  : # WINDOWADDRESS WORKSPACENAME WINDOWCLASS WINDOWTITLE
    case "$WINDOWTITLE" in
          [rR]eddit*)
               notify-send --icon=Reddit \
                'Reddit window opened' \
                "title: $WINDOWTITLE\nworkspace: $WORKSPACENAME\naddress:$WINDOWADDRESS\nclass:$WINDOWCLASS"
                    ;;
     esac
}

event_closewindow() {
  : # WINDOWADDRESS
}

event_movewindow() {
  : # WINDOWADDRESS WORKSPACENAME
}

event_openlayer() {
  : # NAMESPACE
}

event_closelayer() {
  : # NAMESPACE
}

event_submap() {
  : # SUBMAPNAME
  
}

