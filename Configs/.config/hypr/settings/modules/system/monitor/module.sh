#!/bin/bash
_getHeader "$name" "$author"

sel=""
_getConfSelector monitor.conf monitors
_getConfEditor monitor.conf $sel monitors
_reloadModule