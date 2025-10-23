# shlib
Shell Libraries to make your scripting life easier


## Usage Help

Name: shlib.sh

Description: Library Script to provide common variables and functions for shell scripts 
             This script is to be sourced from other scripts. 
             The easiest way is to link it to a directory in common path, like /usr/local/bin 

Synopsis:

    source <path>/shlib[.sh]

Parameter:

    none

Options:

    -d | --debug  (set debug mode)
    -x | --xtrace (set -x)
    -h | --help   (display help)

Extensions:

    Variables set in shlib can be overwritten by calling script. 
    This should be done before sourcing shlib. 
    Below are all Variables set by shlib that can be overwritten by the scripts sourcing shlib.
    
    ### Basic variables to overwrite:
    _ME=$(basename ${0})
    _JUST_ME="${_ME%.*}"
    _THIS_DIR=/root/bin

    _HOSTNAME="srv01"
    _HOSTNAME_FULL="srv01.fullname.org"

    ### Script variables to overwrite:
    _LOG_DIR=/tmp
    _LOG_FILE=my.log
    _DEBUG_FILE=my_debug.log
    _HELP_DIR=${THIS_DIR}/help
    _HELP_FILE=${_HELP_DIR}/README.txt
    _USAGE="Usage: '${_ME}' (OPTIONS) [COMMAND] (TYPE) [(NAME | ALL)]"
    _DEBUG="false"
    _TRACE="false"
    _HELP="false"

    ### Option Arrays to overwrite:
    debug_opts=("-D" "--Debug")
    trace_opts=("-T" "--Trace")
    help_opts=("-H" "--Help")

    ### Loglevel Array:
    loglevels=("INFO" "WARN" "ERROR")
    
    ### Status Array:
    status=("ok" "failed")

    ### Values and Steps
    _VAL=0
    _INCR_BY=1
    _ST=1
    _RC=0

