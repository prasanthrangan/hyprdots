#!/bin/bash -

Usage() { echo "$0 FontFile"; exit 1; }
SayError() { local error=$1; shift; echo "$0: $@"; exit "$error"; }

[ "$#" -ne 1 ] && Usage
width=70
fontfile="$1"

[ -f "$fontfile" ] || SayError 4 'File not found'
list=$(fc-query --format='%{charset}\n' "$fontfile")

for range in $list
do IFS=- read start end <<<"$range"
	if [ "$end" ] ; then
		start=$((16#$start))
		end=$((16#$end))
		for((i=start;i<=end;i++)) ; do
			printf -v char '\\U%x' "$i"
			printf '%b' "$char"
		done
	else
		printf '%b' "\\U$start"
	fi
done | grep -oP '.{'"$width"'}'

