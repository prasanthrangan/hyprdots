#!/usr/bin/python3

import json
import subprocess
import sys
 
def get_keyboards():
    output = subprocess.check_output(["hyprctl","devices","-j"]).decode("utf-8")
    if output:
        devices=json.loads(output)
    return devices["keyboards"]
 
def change_layout():
    active_keymap=False
    for keyboard in get_keyboards():
        if active_keymap and active_keymap != keyboard["active_keymap"]:
            print ("The keyboard %s has the layout %s which differs from %s, equalizing"%(keyboard["name"],keyboard["active_keymap"],active_keymap))
            return False #Not every keyboard is at the same layout currently
        active_keymap=keyboard["active_keymap"]
        command = ["hyprctl","switchxkblayout",keyboard["name"],"next"]
        result = subprocess.run(command,stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
        if result.returncode == 0:
            print("Switched the layout for %s.\n%s" % (keyboard["name"],result.stdout))
        else:
            sys.stderr.write("Error while switching the layout for %s.\n%s\n" % (keyboard["name"],result.stderr))
            got_error = True
    return True #All layouts had been cycled successfully
 
got_error = False
while not change_layout():
    pass
if got_error:
    sys.stderr.write("Some errors were found during the process...\n")
    sys.exit(1)

bash_command = ["notify-send", "-u", "low", "-t", "2000", "Keyboard layout", "Current Layout Changed"]

# Use subprocess.run() to execute the Bash command
result = subprocess.run(bash_command, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
