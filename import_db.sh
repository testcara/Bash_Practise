#!/usr/bin/env bash
set -eo pipefail

usage()
{
  echo "Usage: $0 [-h|-s|-r] [ -d DB_DUMP ] [ -f TARBALL ]"
  exit 2
}

set_variable()
{
	# Declare one local variable
	local varname=$1
	# Move on
	shift
	# If the varname has not been set, set the $varname=$1
	# The exclamation mark before varname tells the shell to replace 
	# that with the value of $varname
	# ACTION=SAVE
	if [ -z "${!varname}" ]; then
		echo eval "$varname=\"$@\""
		eval "$varname=\"$@\""
	else
		echo "Error: $varname already set"
		usage
	fi
}

save_database()
{
	echo "I am saving database $1"
}

restore_database()
{
	echo "I am restoring database $1"
}

save_files()
{
	echo "I am saving files $1"
}

restor_files()
{
	echo "I am restoring files $1"
}

# 1. -s -r can be used directly
# 2. d:/f: can be used -d/-f parameters
# The arguments would be parsed as $OPTARG
# 3. $OPTIND is another parameter getops provided as default.
# It will helps us to get the current index of the command argument  
while getopts 'hsrd:f:' c
do
  case $c in
  	h) usage ;;
    s) set_variable ACTION SAVE ;;
    r) set_variable ACTION RESTORE ;;
    d) set_variable DB_DUMP $OPTARG ;;
    f) set_variable TARBALL $OPTARG ;;
  esac
done

if [ -n "${DB_DUMP}" ]; then
	case $ACTION in
		SAVE) save_database ${DB_DUMP}  ;;
        RESTORE) restore_database ${DB_DUMP} ;;
    esac
fi

if [ -n "${TARBALL}" ]; then
	case $ACTION in
		SAVE) save_files ${TARBALL} ;;
		RESTORE) restore_database ${TARBALL} ;;
	esac
fi
