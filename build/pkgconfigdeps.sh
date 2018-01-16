#!/bin/bash

pkgconfig=`which pkg-config`
test -x $pkgconfig || {
    cat > /dev/null
    exit 0
}

[ $# -ge 1 ] || {
    cat > /dev/null
    exit 0
}

# Under pkgconf, disables dependency resolver
export PKG_CONFIG_MAXIMUM_TRAVERSE_DEPTH=1

case $1 in
-P|--provides)
    while read filename ; do
    case "${filename}" in
    *.pc)
	if [[ "$(dirname ${filename})" =~ pkgconfig ]]; then
	    # Query the dependencies of the package.
	    DIR=`dirname ${filename}`
	    PKG_CONFIG_PATH="$DIR:$DIR/../../share/pkgconfig"
	    export PKG_CONFIG_PATH
	    $pkgconfig --print-provides "$filename" | while read n r v ; do
		[ -n "$n" ] || continue
		# We have a dependency.  Make a note that we need the pkgconfig
		# tool for this package.
		if  [ -n "$r" ] && [ -n "$v" ]; then
		    echo "pkgconfig($n) $r $v"
		else
		    echo "pkgconfig($n)"
		fi
	    done
	fi
	;;
    esac
    done
    ;;
-R|--requires)
    while read filename ; do
    case "${filename}" in
    *.pc)
	if [[ "$(dirname ${filename})" =~ pkgconfig ]]; then
	    # Query the dependencies of the package.
	    DIR=`dirname ${filename}`
	    PKG_CONFIG_PATH="$DIR:$DIR/../../share/pkgconfig"
	    export PKG_CONFIG_PATH
	    $pkgconfig --print-requires --print-requires-private "$filename" | while read n r v ; do
		[ -n "$n" ] || continue
		if  [ -n "$r" ] && [ -n "$v" ]; then
		    echo "pkgconfig($n) $r $v"
		else
		    echo "pkgconfig($n)"
		fi
	    done
	fi
	;;
    esac
    done
    ;;
esac
exit 0
