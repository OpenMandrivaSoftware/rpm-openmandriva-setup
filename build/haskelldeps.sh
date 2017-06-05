#!/bin/sh

# Haskell dependency extractor.
#
# Author(s):	Olivier Thauvin <nanardon@mandriva.org> 
#		Per Øyvind Karlsen <peroyvind@mandriva.org>
# 

provides=0
requires=0

while [ "$#" -ne 0 ]; do
    case $1 in
	-P|--provides)
	    provides=1
	    ;;
	-R|--requires)
	    requires=1
	    ;;
    esac
    shift
done

finddeps () {
    while read file; do
	case "$file" in
	    */usr/share/haskell-deps/*/$1)
		cat "$file" | grep -v '^\s*$'
		;;
	esac
    done
}

if [ $provides -eq 1 ]; then
    finddeps provides
fi

if [ $requires -eq 1 ]; then
    finddeps requires
fi
