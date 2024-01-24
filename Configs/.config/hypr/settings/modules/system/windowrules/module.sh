#!/bin/bash
_getHeader "$name" "$author"

sel=""
_getConfSelector windowrule.conf windowrules
_getConfEditor windowrule.conf $sel windowrules
_reloadModule
