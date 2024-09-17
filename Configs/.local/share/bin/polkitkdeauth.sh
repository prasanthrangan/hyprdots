<<<<<<< HEAD
#!/usr/bin/env bash
=======
#!/usr/bin/env sh
>>>>>>> 22bebeefff2f3fec39ff4397d489e37a780942a2

# Use different directory on NixOS
if [ -d /run/current-system/sw/libexec ]; then
    libDir=/run/current-system/sw/libexec
else
    libDir=/usr/lib
fi

${libDir}/polkit-gnome/polkit-gnome-authentication-agent-1 &
