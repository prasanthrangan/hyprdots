#!/bin/bash
_getHeader "$name" "$author"

sel=""
_getConfSelector environment.conf environments
_getConfEditor environment.conf $sel environments
_reloadModule
