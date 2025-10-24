#!/usr/bin/env bash
################################################################################
#
# Name:   shlib.sh
#
# Description: Library Script to provide common variables
#              and functions for shell scripts (to be sourced from other scripts).
#
# Author:      sobermeyer
#
# History:     2025-10-15 - initally created
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# Copyright: 2025 sobermeyer
#
################################################################################
set +x
################################################################################
## Constants and Variables

## this script (gets resolved to calling script that sources this library)
declare -r __CALLER=$(basename ${0})
## without extension
declare -r __JUST_CALLER=${__CALLER%.*}
## path to caller script
declare -r __CALLER_DIR=$(cd -- "$( dirname -- "${__CALLER}" )" &> /dev/null && pwd)

## get current date
_date() {
    printf "$(date +%Y-%m-%d\ %H:%M:%S)"
}

## log directory
declare -r __LOG_DIR="/var/log"

## set logdir (if not set in caller script)
[ -z ${_LOG_DIR} ] && {
    declare _LOG_DIR=${__LOG_DIR}
}

## check logdir
if [[ ! -d ${_LOG_DIR} ]] || [[ ! -w ${_LOG_DIR} ]]; then
    _date && printf " *** ERROR: Log Directory '${_LOG_DIR}' not found or accessible! ***\n"
    exit 3
fi

## logfile
declare -r __LOG_FILE=${_LOG_DIR}/${__JUST_CALLER}.log
## debugfile
declare -r __DEBUG_FILE=${_LOG_DIR}/${__JUST_CALLER}_debug.log

## set log file (if not set in caller script)
[ -z ${_LOG_FILE} ] && {
    declare _LOG_FILE=${__LOG_FILE}
    touch ${_LOG_FILE}
}
## set debug file (if not set in caller script)
[ -z ${_DEBUG_FILE} ] && {
    declare _DEBUG_FILE=${__DEBUG_FILE}
    touch ${_DEBUG_FILE}
}

## help files
declare -r __HELP_DIR=${__CALLER_DIR}
declare -r __HELP_FILE=${__HELP_DIR}/README.txt

## set helpdir and file (if not set in caller script)
[ -z ${_HELP_DIR} ] && {
    declare _HELP_DIR=${__HELP_DIR}
}

[ -z ${_HELP_FILE} ] && {
    declare _HELP_FILE=${__HELP_FILE}
}

## check helpdir (only warn if not found)
if [[ ! -d ${_HELP_DIR} ]] || [[ ! -r ${_HELP_DIR} ]]; then
    _date && printf " !!! WARNING: Help Directory '${_HELP_DIR}' not found or readable! !!!\n" | tee -a ${_LOG_FILE}
fi

## basic usage string constant
declare -r __USAGE="Usage: '${__CALLER}' (OPTIONS) [COMMAND] (TYPE) [(NAME | ALL)]"

## set usage string (if not set in caller script)
[ -z "${_USAGE}" ] && {
    declare _USAGE="${__USAGE}"
}

################################################################################
## set option identifier arrays (if not set in caller script)
[ -z ${debug_opts} ] || [ "$(echo ${#debug_opts[@]})" == "0" ] && {
    declare -a debug_opts=("-d" "--debug")
}

[ -z ${trace_opts} ] || [ "$(echo ${#trace_opts[@]})" == "0" ] && {
    declare -a trace_opts=("-x" "--xtrace")
}

[ -z ${help_opts} ] || [ "$(echo ${#help_opts[@]})" == "0" ] && {
    declare -a help_opts=("-h" "--help")
}

## "booleans"
declare -r _F="false"
declare -r _T="true"

## option variables
declare -r __DEBUG=${_F}
declare -r __TRACE=${_F}
declare -r __HELP=${_F}

[ -z ${_DEBUG} ] && {
    declare _DEBUG=${__DEBUG}
}

[ -z ${_TRACE} ] && {
    declare _TRACE=${__TRACE}
}

[ -z ${_HELP} ] && {
    declare _HELP=${__HELP}
}


################################################################################

## display help (if help file is available, else display usage)
_help () {
    local _str
    [ ! -z "${1}" ] && _HELP_FILE="${1}"
    [ ! -z "${2}" ] && _LOG_FILE="${2}"
    if [[ -r ${_HELP_FILE} ]]; then
        cat ${_HELP_FILE} | grep -v '#' | more
    else
        printf "\n\t${_USAGE}\n"
        printf "\n"
        _date >> ${_LOG_FILE} && \
        printf " WARNING: No help file '$(basename ${_HELP_FILE})' in directory '${_HELP_DIR}' found.\n" >> ${_LOG_FILE}
    fi;
    exit 0;
}

## process option arguments
parse_opts() {
    local _ARG_LEN=${#1}
    local _P="##########"
    [ ${_ARG_LEN} -gt 0 ] && {
        local _ARGS=-1
        while [[ ${_ARGS} -le ${_ARG_LEN} ]]; do
        # echo "ARGs: ${@}"
        case "${1,,}" in
            "${help_opts[0]}"|"${help_opts[1]}")
                _HELP="true"
                let _ARGS+=1
                shift;
                _help
                break;
                ;;
            "${trace_opts[0]}"|"${trace_opts[1]}")
                _TRACE="true"
                _date && printf " ${_P} TRACE: Trace Mode active: ${_TRACE} ${_P}\n\n" | tee -a ${_DEBUG_FILE}
                set -x
                let _ARGS+=1
                shift;
                ;;
            "${debug_opts[0]}" | "${debug_opts[1]}" )
                _DEBUG="true"
                _date && printf " ${_P} DEBUG: Debug Mode active: ${_DEBUG} ${_P}\n\n" | tee -a ${_DEBUG_FILE}
                let _ARGS+=1
                shift;
                ;;
            *)
                let _ARGS+=1
                ;;
            esac
        done
    }
}

parse_opts ${*}

################################################################################
## more constants, variables and arrays

## host
declare -r __HOSTNAME_FULL=$(hostname --all-fqdn)
declare -r __HOSTNAME=$(hostname -s)

## int value constant
declare -r __VAL=0
## increment by constant
declare -r __INCR_BY=1
# Step
declare -r __ST=(${__VAL} + 1)
# Returncode
declare -r __RC=${__VAL}


## loglevels
if [[ loglevels ]] || [[ "$(echo ${loglevels[@]})" == "0" ]]; then
    declare -a loglevels=("INFO"
                          "DEBUG"
                          "WARNING"
                          "ERROR"
                          "FATAL")
fi

#declare -p loglevels && echo $?

## logcodes based on loglevels
declare -A logcodes=()

## status messages
if [[ status ]] || [[ "$(echo ${status[@]})" == "0" ]] ; then
    declare -a status=("done"
                       "failed"
                       "completed"
                       "completed with warnings"
                       "completed with errors")
fi

#declare -p status && echo $?

## statuscodes based on status messages
declare -A statuscodes=()

## length of loglevel and status arrays
_LOGLEV_LEN=$(echo ${#loglevels[@]})
_STATUS_LEN=$(echo ${#status[@]})

## reduce length by 1 to accomodate key sequence (starts with 0)
let _LOGLEV_LEN-=1
let _STATUS_LEN-=1

################################################################################
## basic arrays and functions

## log message
_logmsg () {
    local _LL=0
    local _LEN=0
    [ -z ${2} ] && {
        # regular logging
        printf " ${1//\"/}\n"
    } || {
        # severity code for log level was passed
        if [[ ${2} =~ ^[0-9]+$ ]] && [[ ${2} -le ${_LOGLEV_LEN} ]]; then
            printf '%-10s %-60s\n' " ${loglevels[${2}]}:" "${1//\"/}"
        else
            printf '%-10s %-60s\n' " ${loglevels[${_LOGLEV_LEN}]}:" "${1//\"/}"
        fi
    }
}

## log message with date
_logd () {
    _date && _logmsg "${1}" ${2}
}

## shorthand _log and log defaults to _logd
_log () {
    # no error code
    [ -z ${3} ] && {
        _logd "${1/\"//}" ${2}
    } || {
        # error code or step was passed
        _logd "[${2}] ${1/\"//}" ${3}
    }
}

## cascade to log for easier coding
log () {
    _log "${1}" ${2} ${3}
}

## predefined messages
_info() {
    # get debug log level a.k.a label
    local _LL=${logcodes["INFO"]}
    _log "${1/\"//}" ${2} ${_LL}
}

_debug() {
    if [[ "${_DEBUG}" == "true" ]]; then
        # get debug log level a.k.a label
        local _LL=${logcodes["DEBUG"]}
        _log "${1/\"//}" ${2} ${_LL}
    fi
}

_warn() {
    # get debug log level a.k.a label
    local _LL=${logcodes["WARNING"]}
    _log "!!! ${1/\"//} !!!" ${2} ${_LL}
}

_error() {
    local _LL=${logcodes["ERROR"]}
    _log "*** ${1/\"//} ***" ${2} ${_LL}
}

################################################################################
## basic and useful functions

## fill arrays by function
fill_code_arrays() {
    ## init _val with constant __VAL
    local _val=${__VAL}
    ## fill logcodes array
    for s in ${loglevels[*]}; do
        _key="${loglevels[${_val}]}"
        [ ! -z "${_key}" ] && {
            logcodes["${_key}"]=${_val}
            let _val+=1
        }
    done
    _val=${__VAL}

    ## fill statuscodes array
    for s in ${status[*]}; do
        _key="${status[${_val}]}"
        [ ! -z "${_key}" ] && {
            statuscodes["${_key}"]=${_val}
            let _val+=1
        }
    done
    _val=${__VAL}
}

## usage string "$(basename $0)" "Message"
set_usage () {
    local _usage
    if ! [[ -z ${1} ]] ; then
        _usage="Usage: ${1}"
    else
        _usage="${__USAGE}"
    fi
    echo "${_usage}"
}


## check for first parameter
first_param_set () {
    local _return="false"
    if ! [[ -z ${1} ]]; then
        _return="true"
    fi
    echo "${_return}"
}

## check if user is <username>
user_is () {
    local _return="false"
    if ! [[ -z ${1} ]] && [[ "$(id -un)" == "${1}" ]]; then
        _return="true"
    fi
    echo "${_return}"
}

## check if directory exists, is readable and can change into it
dir_writable () {
    local _return="false"
    if ! [[ -z ${1} ]] && [[ -d ${$1} ]] && [[ -w ${$1} ]]; then
        _return="true"
    fi
    echo "${_return}"
}

dir_readable () {
    local _return="false"
    if ! [[ -z ${1} ]] && [[ -d ${$1} ]] && [[ -r ${$1} ]]; then
        _return="true"
    fi
    echo "${_return}"
}


dir_full_access_exists () {
    local _return="false"
    if ! [[ -z ${1} ]] && [[ -d ${$1} ]] && [[ -x ${$1} ]] && [[ -r ${$1} ]] && [[ -w ${$1} ]]; then
        _return="true"
    fi
    echo "${_return}"
}

## check if file exists and is readable
file_exists () {
    local _return="false"
    if ! [[ -z ${1} ]] && [[ -a ${$1} ]] && [[ -r ${$1} ]]; then
        _return="true"
    fi
    echo "${_return}"
}

## check if file exists and is writable
file_writable () {
    local _return="false"
    if ! [[ -z ${1} ]] && [[ -a ${$1} ]] && [[ -w ${$1} ]]; then
        _return="true"
    fi
    echo "${_return}"
}

filew () {
    file_writable ${1}
}

## check if file exists and is ececutable
file_executable () {
    local _return="false"
    if ! [[ -z ${1} ]] && [[ -a ${$1} ]] && [[ -x ${$1} ]]; then
        _return="true"
    fi
    echo "${_return}"
}

filex () {
    file_executable ${1}
}

################################################################################
## increment or set values
incr_val () {
    local _val=${1}            # get value to increment
    local _incr=${__INCR_BY}   # increment by
    ## override _incr with 2nd argument if present
    if ! [[ -z ${2} ]]; then
        let _incr=${2}
    fi
    ## increment value based on first argument
    if ! [[ -z ${1} ]]; then
        let _val+=${_incr}
    else
        let _val=${_incr}
    fi
    echo ${_val}
}

## set value to first argument, or initialize it
set_val () {
    local _val=${__VAL}
    local _incr=${__INCR_BY}
    if ! [[ -z ${2} ]]; then
        let _incr=${2}
    fi
    if ! [[ -z ${1} ]]; then
        let _val=${1}
    else
        let _val+=${_incr}
    fi
    echo ${_val}
}

## shorthand functions to set / increment steps or returncodes

# set step
set_st () {
    ## set value based on first argument
    if ! [[ -z ${1} ]]; then
        set_val ${*}
    else
        set_val 1
    fi
}

set_rc () {
    set_st ${*}
}

incr_st () {
    incr_val ${*}
}

incr_rc () {
    incr_val ${*}
}


################################################################################
## init this library

## run local functions
fill_code_arrays;

## initialize variables with constant values (if not set in caller script)

## environment
[ -z ${_ME} ] && {
    _ME=${__CALLER}
}

[ -z ${_JUST_ME} ] && {
    _JUST_ME=${__JUST_ME}
}

[ -z ${_THIS_DIR} ] && {
    _THIS_DIR=${__CALLER_DIR}
}

[ -z ${_HOSTNAME_FULL} ] && {
    _HOSTNAME_FULL=${__HOSTNAME_FULL}
}

[ -z ${_HOSTNAME} ] && {
    _HOSTNAME=${__HOSTNAME}
}

## values and steps
[ -z ${_VAL} ] && {
    _VAL=${__VAL}
}

[ -z ${_INCR_BY} ] && {
    _INCR_BY=${__INCR_BY}
}

[ -z ${_ST} ] && {
    _ST=${__ST}
}

[ -z ${_RC} ] && {
    _RC=${__RC}
}

## EOF
