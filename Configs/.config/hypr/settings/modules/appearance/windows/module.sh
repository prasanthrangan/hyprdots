#!/bin/bash
_getHeader "$name" "$author"

sel=""
_getConfSelector window.conf windows
_getConfEditor window.conf $sel windows
_reloadModule