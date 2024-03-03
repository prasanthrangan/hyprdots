#!/bin/bash

export LIBVIRT_DEFAULT_URI="qemu:///system"

/usr/bin/virsh start $1 > /dev/null 2>&1
/usr/bin/virt-viewer -f -w -a $1 > /dev/null 2>&1
