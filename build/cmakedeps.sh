#!/bin/bash

case $1 in
-P|--provides)
	(while read filename ; do
		case "${filename}" in
		*-config.cmake)
			N="`basename \"${filename}\" -config.cmake`"
			echo "cmake($N)"
			;;
		*Config.cmake)
			N="`basename \"${filename}\" Config.cmake`"
			echo "cmake($N)"
			;;
		*/Find*.cmake)
			N="`basename \"${filename}\" .cmake |cut -b5-`"
			echo "cmake($N)"
			;;
		esac
	done) | sort | uniq
	;;
-R|--requires)
	if false; then # NOT YET READY
	(while read filename ; do
		case "${filename}" in
		*.cmake)
			if grep -qiE '^\s*find_package\s*\([^)]*required' "${filename}"; then
				grep -iE '^\s*find_package\s*\([^)]*required' ${filename} |sed -e 's,.*(,,;s,^\s*,,;s,\s.*,,' |while read N; do
					echo "$N" |grep -q '\$' || echo "cmake($N)"
				done
			fi
			if grep -qiE '^\s*find_dependency\s*\([^)]*' "${filename}"; then
				grep -iE '^\s*find_dependency\s*\([^)]*' ${filename} |sed -e 's,.*(,,;s,^\s*,,;s,\s.*,,' |while read N; do
					echo "$N" |grep -q '\$' || echo "cmake($N)"
				done
			fi
			;;
		esac
	done) | sort | uniq
	fi
	;;
esac
exit 0
