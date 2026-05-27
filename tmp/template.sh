#!/usr/bin/env bash
#
# <NAME>.sh
#
# Description:
#               Shell script to ...
#
#
# Dependencies/Requirements:
#               ...
#
################################################################################
#
# Arguments:
#           none
#
#   Options:
#           -d | --debug        Debug mode. Emits debug messages to console/logfile
#           -o | --only-debug   Debug Only mode. Only debug messages and no code execution
#           -l | --log          Log mode. Emits messages to  a logfile as well as console
#           -f | --file [FILE]  Logfile to override predefined Logfile (requires full path)
#           -x | --trace        Trace mode. Set -x for complete run view + debug
#
# Functions:
#           - _log:         logs a message to console, or (if specified) a logfile
#           - _debug:       uses _log to log a debug message to console/logfile
#
################################################################################
# Shell Script Template to use shlib functionality in one script.
# Author: s.obermeyer@t-online.de
#   Date: 2026-04-20
#
################################################################################

_USER=$(id -un)
# check if user oracle is executing this script
[ ! ${_USER} == 'oracle' ] && {
    echo "$(date) ERROR: This script must be executed by user \"oracle\". Current user is \"$(id -un)\"";
    exit 1;
}

## internal variables and functions
_RC=0
_LINE="********************************************************************************"
_HOME=${HOME}
_PROFILE=${_HOME}/.bash_profile
_HOST=$(hostname -s)
_THIS_SCR=$(basename ${0})
## script directory
_THIS_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
## sub script to call - change part of name you wish to change for subscript (optional)
#_SCR=$(echo "${_THIS_DIR}/${_THIS_SCR}" | sed -e "s/_mytmp/_thatscript/g")
_SCR=${_THIS_DIR}/${_THIS_SCR}

## logging (Logfile defaults to scriptname with .log extension instead of .sh)
_LOGDIR=/tmp
_LOGFILE=${_LOGDIR}/$(echo "${_THIS_SCR}" | sed -e "s/.sh/.log/g")
## initialize Logfile?
_INIT_LOGFILE=false
## overall server job log
_SRV_LOG=${_HOME}/log/$(hostname -s)_job.log
[ ! -a ${_SRV_LOG} ] && touch ${_SRV_LOG}

## set debug and/or tracing defaults
_LOG=false        ## logging active or not
_FILE=false       ## logfile enabled?
_DEBUG=false      ## simple debug output
_DEBUG_ONLY=false ## only debug output and no code execution
_TRACE=false      ## bash trace with set -x and enables debug mode

## set initial message for debug
_INT_MSG="internally"
[ ${_LOG} ] && _LOG_MSG=${_INT_MSG}
[ ${_FILE} ] && _FILE_MSG=${_INT_MSG}
[ ${_DEBUG} ] && _DEBUG_MSG=${_INT_MSG}
[ ${_DEBUG_ONLY} ] && _DEBUG_ONLY_MSG=${_INT_MSG}
[ ${_TRACE} ] && _TRACE_MSG=${_INT_MSG}

## call options for subscripts and trace
_CALL_OPT=""      ## pass debug option to subscript
_BASH_OPT="+x"    ## run this script with bash option (-x for trace)

## processing script options for debug or tracing to override internal settings
OPTS=$(getopt -o dlotf: --long debug,log,only-debug,trace,file: -n ${_THIS_SCR} -- "$@")

## Note the quotes around "${OPTS}": they are essential! Using echo, since _log is not yet available
eval set -- "${OPTS}"
while true; do
    case "$1" in
    -d | --debug )
        _DEBUG=true;
        _CALL_OPT="${1}"
        _DEBUG_MSG="by option \"-d | --debug\""
        shift;
    ;;
    -l | --log)
        _LOG=true;
        _LOG_MSG="by option \"-l | --log\""
        shift;
    ;;
    -o | --only-debug)
        _DEBUG_ONLY=true;
        _DEBUG_ONLY_MSG="by option \"-o | --only-debug\""
        # also enable debug
        _DEBUG=true;
        _CALL_OPT="${1}"
        shift;
    ;;
    -t | --trace)
        _TRACE=true;
        _TRACE_MSG="by option \"-t | --trace\""
        # also enable debug
        _DEBUG=true;
        _CALL_OPT="${1}"
        _BASH_OPT="-x"
        shift;
    ;;
    -f | --file)
        _LOG=true;
        _FILE=true;
        _FILE_MSG="by option \"-f | --file\""
        shift;
        # set logfile (if filename was provided as arg, and is not just another option)
        [ "${1:0:1}" == "-" ] || _LOGFILE="${1}"
        shift;
    ;;
    --) shift; break
    ;;
    * ) break
    ;;
    esac
done

## remove set option (if still present)
[ "${1}" == "--" ] && shift;

## set bash trace option [trace -x | notrace +x]
set ${_BASH_OPT}

################################################################################
## Functions

## logging
_log() {
    echo "$(date): ${1}";
}

## debugging output
_debug() {
    if ${_DEBUG}; then
        _log "${1}"
    fi
}

################################################################################
## debug values
_debug "${_LINE}"
_debug "Script: ${_THIS_SCR}"
_debug "Arguments: \"${*}\""
_debug "User ${_USER}'s bash profile: ${_PROFILE}"
_debug "_USER=${_USER}"
_debug "_HOST=${_HOST}"
_debug "_HOME: ${_HOME}"
_debug "_THIS_DIR=${_THIS_DIR}"
_debug "_THIS_SCR=${_THIS_SCR}"
_debug "_SCR=${_SCR}"
_debug "_SRV_LOG=${_SRV_LOG}"
_debug "_LOGFILE=${_LOGFILE}"
_debug "_INIT_LOGFILE=${_INIT_LOGFILE}"

if ${_DEBUG_ONLY}; then
    _debug "${_LINE}"
    _debug "Debug Only Option set ${_DEBUG_ONLY_MSG}. Setting Debug Only Mode to: TRUE";
    _debug "Debug Option was also set internally by Debug Only Option"
elif ${_TRACE}; then
    _debug "${_LINE}"
    _debug "Trace Option set ${_TRACE_MSG}. Setting Trace and Debug to: TRUE";
    _debug "Debug Option was also set internally by Trace Option"
elif ${_DEBUG}; then
    _debug "${_LINE}"
    _debug "Debug Option set ${_DEBUG}. Setting Debug to: TRUE";
fi

if ${_FILE}; then
    _debug "${_LINE}"
    _debug "Logfile Option set ${_FILE_MSG}. Setting Logging to: TRUE"
    _debug "Logfile is set to: ${_LOGFILE}";
    _debug "Log Option was also set internally by Logfile Option"
elif ${_LOG}; then
    _debug "${_LINE}"
    _debug "Log Option set ${_LOG_MSG}. Setting Logging to: TRUE";
fi

################################################################################
## pre-processing

## set logfile
if ${_LOG}; then
    declare -a _MSG=("writable." "not writable!")
    ## check logdir and set logfile
    [ -w ${_LOGDIR} ] && [ -x ${_LOGDIR} ] || _RC=1
    _LOGDIR_MSG="Log directory \"${_LOGDIR}\" is ${_MSG[${_RC}]}."
    [ ${_RC} -ne 0 ] && {
        _log "*** ERROR: ${_LOGDIR_MSG}"
        exit ${_RC}
        }
    # rewrite function _log to include logfile
    _log () {
        echo "$(date): ${1}" | tee -a ${_LOGFILE};
    }
    _debug "${_LINE}"
    _debug "${_LOGDIR_MSG}"
    _debug "Logfile set to: \"${_LOGFILE}\"."
    ## initialize logfile, if specified
    if [[ ${_INIT_LOGFILE} ]]; then
        _debug "Initialize Logfile: \"${_LOGFILE}\"."
        [ -a ${_LOGFILE} ] && echo 0>${_LOGFILE} || touch ${_LOGFILE}
    fi
else
    _debug "${_THIS_SCR}: Logging not enabled."
fi


################################################################################
## set line and start processing
_log "${_LINE}"
_log "Running ${_THIS_SCR} ..."

################################################################################
# script variables and code
################################################################################

### Variables
#_SOME_VAR=SomeVal

### debug variable values
# _debug "${_LINE}"
# _debug "Home: ${_HOME}"
# _debug "Host: ${_HOST}"

### check requirements
# if  [[ -d ${_HOME} && ! -z ${_HOST} ]];
# then
#     _debug "INFO: All script requirements met."
# else
#     _log "*** ERROR: Requirements not met. Run \"${_THIS_SCR} --debug\" to see more. ***";
#     exit 1;
# fi

################################################################################
## Code here (you should decide to run it inside the ! ${_DEBUG_ONLY} block below)...


# ## Running main script, if not _DEBUG_ONLY
# if ! ${_DEBUG_ONLY}; then
#     _log "Running: ${_SH_RUN}..."
#
#   ## Your Code in here...
#
#     ## add errors to $hostname_error.log
#     if [[ -a ${_SRV_LOG} && -w ${_SRV_LOG} ]]; then
#         _log "Adding AUDIT Dump Errors to Server Logfile ${_SRV_LOG}"
#         cat ${_LOGFILE} | grep -e 'ERROR' | sed -e "s/:\ \*\*\*/\ [$(basename ${_SH_RUN})]/g" >> ${_SRV_LOG}
#     else
#         _log "WARNING: Server Logfile \"${_SRV_LOG}\" not found, or accessible."
#     fi
# else
#     _debug "Adding Errors to Server Logfile ${_SRV_LOG}"
#     _debug "DEBUG: Done running ${_SH_RUN} in DEBUG-ONLY Mode."
# fi

################################################################################
## Setting Returncode and closing message
_RC="${?}"
_log "Done ${_THIS_SCR} with Return: [${_RC}]..."

################################################################################
## reset tracing
set +x

exit ${_RC}
