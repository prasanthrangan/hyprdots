#!/bin/bash
_getHeader "$name"

sel=""
_getConfSelector keybinding.conf keybindings
_getConfEditor keybinding.conf $sel keybindings
_reloadModule

