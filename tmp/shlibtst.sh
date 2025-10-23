#!/usr/bin/env bash

################################################################################

## Test Script for shlib.sh

## put shlib.sh into path directory

## as root
# ln -fs $(pwd)/shlib.sh /root/bin/shlib

## for others, like oracle,...
# ln -fs /home/oracle/scripts/shlib/shlib.sh /home/oracle/.local/bin/shlib

################################################################################

## mandatory checks first

## usage string
_USAGE_STR="'$(basename ${0})' (OPTIONS) [COMMAND] (TYPE) [(NAME | ALL)]"

## check for any paramter or option
[ -z ${1} ] && {
    printf "Usage: ${_USAGE_STR}\n"
    exit 1;
}

## user to execute this script (change to username)
_USER="${USER}"
#_USER="root"

## check if user is root (do before sourcing)
[ "$(id -un)" = "${_USER}" ] || {
    printf "ERROR: *** This script must be executed by user '${_USER}'. Current user is '$(id -un)'.***\n";
    exit 2;
}

###############################################################################
## now source shlib
source shlib

echo \#\# variables from shlib
echo "ME=${__CALLER}"
echo "JUST_ME=${__JUST_CALLER}"
echo "THIS_DIR=${__CALLER_DIR}"
echo "HOST: ${__HOSTNAME}"
echo "FULL HOST: ${__HOSTNAME_FULL}"

## set _USAGE to _USAGE_STR
_USAGE=$(set_usage "${_USAGE_STR}")

## check first
[ $(first_param_set ${1}) == "false" ] && {
    printf "${_USAGE}\n" && exit 1;
}


echo "Debug Options: ${debug_opts[@]}"
echo "Trace Options: ${trace_opts[@]}}"
echo "Help Options: ${help_opts[@]}"

echo "DEBUG: ${_DEBUG}"
echo "TRACE: ${_TRACE}"
echo "HELP: ${_HELP}"

echo "Loglevels: ${loglevels[@]}"
echo "Status: ${status[@]}"

## getting values for constants
echo "VAL: ${_VAL}"
echo "INCR_BY: ${_INCR_BY}"

## usage string from constants
echo "U0: ${__USAGE}"
## usage string with empty message, so taken from constants
_USAGE=$(set_usage)
echo "U1: ${_USAGE}"
## usage string with message, so take script name and message
_USAGE=$(set_usage "A great program:-)")
echo "U2: ${_USAGE}"

## Status and Log Levels and Codes
echo "'WARNING' Code: ${logcodes["WARNING"]}"
echo "'DEBUG' Code: ${logcodes["DEBUG"]}"
echo "'DEBUG' Message by Code [1]: ${loglevels[1]}"
echo "'INFO' Message by Code [0]: ${loglevels[0]}"
echo "Status 'completed with warnings' Code: ${statuscodes["completed with warnings"]}"
echo "Status 'completed' Code: ${statuscodes["completed"]}"
echo "Status 'completed' by Code[2]: ${status[2]}"
echo "All Status Codes: ${statuscodes[@]}"
echo "All Levels: ${loglevels[@]}"
echo "All Loglevel Codes: ${logcodes[@]}"

## logging (with loglevel codes)
log "Say What" 0
log "Say Yeah" 1
log "Yeah What?" 2
log "Do or Don't" 3
log "Done" 4
## blank line
log

_info "bla bla bla" 21
_info "blub blub blub"

_debug "ey Yo'"
_debug "Hi there" 27

_warn "evil coming" 665
_warn "evil arrived"

# explicit returncode
_error "BaD BAd bAD" 254
# no extra errorcode
_error "vEry BaD"

_debug "First Param set? $(first_param_set ${*})"


################################################################################
## initialize step & returncode
_ST=$(set_st 1)
_RC=$(set_rc)
echo "Step: ${_ST} - Returncode: ${_RC}"

## use incr_st and incr_rc
_ST=$(incr_st ${_ST})
_RC=$(incr_rc ${_RC})
echo "Step: ${_ST} - Returncode: ${_RC}"

_ST=$(incr_st ${_ST} 5) ## increment by 5
_RC=$(incr_rc ${_RC} 5)
echo "Step: ${_ST} - Returncode: ${_RC}"

## set static values
_ST=$(set_st 12)
_RC=$(set_rc 125)
echo "Step: ${_ST} - Returncode: ${_RC}"


################################################################################
## list all functions
    if [[ "${_TRACE}" == "true" ]]; then
        echo "$(date +%Y-%m-%d\ %H:%M:%S) Arguments to Caller: ${*}"
        echo "$(date +%Y-%m-%d\ %H:%M:%S) Functions in shell: "
        declare -F
    fi


echo \#\# EOF shlibtst

exit ${?}
