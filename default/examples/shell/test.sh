#!/usr/bin/env bash
#

# declare -a _BIN_LIST=("sqlplus" "sql" "opatch" "rman" "sqlldr" "impdp" "expdp" "java" "git" );
#   for b in "${_BIN_LIST[@]}"
#   do
#       unset ${b^^}
#       B=$(which $b 2>/dev/null || echo "-1")
#       [ ${B} != "-1" ] && {
#         export ${b^^}=${B}
#       }
#   done#>>${_SRVENV}

# for b in "${_BIN_LIST[@]}"
#   do
#   B=${b^^}
#       [ ! -z ${!B} ] && {
#         printf "%-12s %-20s\n" ${B} ${!B}
#       } || {
#         printf "%-12s %-20s\n" ${B} "notfound!"
#       }
#   done


# $ find $ORAROOT/ -type f -name srvctl 2>/dev/null
# /u01/app/oracle/product/19.0.0.0/dbhome_1/bin/srvctl
# /u01/app/oracle/product/19.0.0.0/dbhome_2/bin/srvctl
# /u01/app/19.18.0.0/grid/crs/utl/srvctl
# /u01/app/19.18.0.0/grid/bin/srvctl
# $ find $ORAROOT/ -type f -name crsctl 2>/dev/null
# /u01/app/19.18.0.0/grid/bin/crsctl
# $ CRSCTL=$(find $ORAROOT/ -type f -name crsctl 2>/dev/null)
# $ echo $CRSCTL
# /u01/app/19.18.0.0/grid/bin/crsctl
# $ D=$(dirname $CRSCTL)
# $ echo $D
# /u01/app/19.18.0.0/grid/bin
# $ echo $D|sed "s/\/bin//g"
# /u01/app/19.18.0.0/grid --> GRID_HOME

# ## run once in .bashrc
# _SRVENV=~/.bash_node
# get_server_env() {
#     OP="C"
#     [ ! -z ${1} ] && {
#     OPT=${1}
#     [ ${OPT} == '-r' ] || [ ${OPT} == '--refresh' ] && OP="R"
#     }
#     [ -a ${_SRVENV} ] && [ ${OP} != "R" ] && {
#         # source it
#         echo "Sourcing ${_SRVENV}"
#         # . ${_SRVENV}
#     } || {
#         [ ${OP} == "R" ] && {
#             # echo "Refresh Option specified (${OPT})"
#             echo 0>${_SRVENV} >/dev/null
#             }
#             ## if not exsts, create and fill file with server env
#             echo "#" >> ${_SRVENV}
#             echo "# Server Envrionment for $(hostname)" >> ${_SRVENV}
#             echo "# $(date)" >> ${_SRVENV}
#             echo "#" >> ${_SRVENV}
#             echo "# Hostname" >> ${_SRVENV}
#             echo "export HOST=$(hostname)" >> ${_SRVENV}
#             echo "# Hostname Full Qualified" >> ${_SRVENV}
#             echo "export HOSTFQDN=$(hostname --fqdn)" >> ${_SRVENV}
#             echo "# Operating System" >> ${_SRVENV}
#             echo "export OS=$(uname)" >> ${_SRVENV}
#             echo "# OS Release" >> ${_SRVENV}
#             echo "export RELEASE=$(uname -r)" >> ${_SRVENV}
#             echo "#" >> ${_SRVENV}
#             # now source it
#             . ${_SRVENV}
#     }
# }

# get_server_env $1

# test_env() {
#     [ ! -z ${1} ] && {
#         OPT=${1}
#         echo "Option: $1"
#         [ ${OPT} == '-r' ] || [ ${OPT} == '--refresh' ] && echo "Refresh"
#         } || {
#             echo "no option"
#         }
# }

# test_env $1

#!/bin/bash

# while getopts ":abc" OPTION; do

# #echo $OPTION

#     case "$OPTION" in
#     a|-agree)
#     echo "Option a used"
#     ;;
#     b|-bold)
#     echo "Option b used"
#     ;;
#     c|-cold)
#     echo "Option c used"
#     ;;
#     ?)
#     echo "Usage: $(basename $0) [-a|--agree] [-b|--bold] [-c|--cold]"
#     exit 1
#     ;;
#     esac

# done

# $ getopt -help

# Usage:
#  getopt <optstring> <parameters>
#  getopt [options] [--] <optstring> <parameters>
#  getopt [options] -o|--options <optstring> [options] [--] <parameters>

# Parse command options.

# Options:
#  -a, --alternative             allow long options starting with single -
#  -l, --longoptions <longopts>  the long options to be recognized
#  -n, --name <progname>         the name under which errors are reported
#  -o, --options <optstring>     the short options to be recognized
#  -q, --quiet                   disable error reporting by getopt(3)
#  -Q, --quiet-output            no normal output
#  -s, --shell <shell>           set quoting conventions to those of <shell>
#  -T, --test                    test for getopt(1) version
#  -u, --unquoted                do not quote the output

#  -h, --help                    display this help
#  -V, --version                 display version

# For more details see getopt(1).
# set -x
# TEMP=$(getopt -o abc: --longoptions agree,bold,cold -n 'test.sh' -- "$@")
# # Note the quotes around '$TEMP': they are essential!
# eval set -- "$TEMP"
# _rc=0;
# while true; do
#     case "$1" in
#     -a | --agree )
#     echo "Option $1 used"; shift; break
#     ;;
#     -b | --bold )
#     echo "Option $1 used"; shift; break
#     ;;
#     -c | --cold )
#     echo "Option $1 used"; shift; break
#     ;;
#     ?) shift; _rc=1; break
#     ;;
#     -- ) shift; _rc=2; break
#     ;;
#     *) shift; _rc=3; break
#     ;;
#     esac

# done
# [ $_rc -ne 0 ] && echo "$_rc Usage: $(basename $0) [-a|--agree] [-b|--bold] [-c|--cold]";

# echo "${0}:"
# echo "Num Args: ${#}"
# echo "My PID: ${$}"
# _SCR=/home/oracle/scripts/lib/default/_library/libraryctl
# echo;
# echo "Executing ${_SCR}":
# echo;
# ${_SCR}
# echo;
# # echo Sourcing ${_SCR}:
# # echo;
# # . ${_SCR}
# # echo "test function in ${_SCR}"
# # _test;
# # used when script is sourced and not called!
# [ '${BASH_SOURCE[0]}' == '${BASH_SOURCE[1]}' ] && {
#     echo Equal
#     _FILE=$(basename '${BASH_SOURCE[0]}')
#     _THIS_DIR=$(dirname ${_FILE})
#     _THIS_FILE=$(basename ${_FILE})
#     _CALLER_PID=${_THIS_PID}
# } || {
#     echo Not Equal


# }

# echo $(pgrep -l ${0})

# # _test
# function _test() {
#     echo "LibBase:    ${_LIB_BASE}"
#     echo "Dir:        ${_THIS_DIR}"
#     echo "File:       ${_THIS_FILE}"
#     echo "LibName:    ${_LIB_NAME}"
#     echo "Function:   ${FUNCNAME[0]}";
#     echo "Source0:    ${BASH_SOURCE[0]} - Source1: ${BASH_SOURCE[1]}"
#     echo "In Library: ${_THIS_FILE}."
#     echo "My PID:     ${_THIS_PID}"
#     echo "Caller PID: ${_CALLER_PID}"
#     echo;
# }

# echo "Running Test Function in lib"
# _test;

# echo "Function:   ${FUNCNAME[0]}";
# echo "Source0:    ${BASH_SOURCE[0]}"
# echo "Source1:    ${BASH_SOURCE[1]}"


# _SCR=/home/oracle/scripts/lib/default/_library/libraryctl
# echo;
# echo "Executing ${_SCR} without options or arguments":
# echo;
# /home/oracle/scripts/lib/default/_library/libraryctl
# echo;
# echo "Executing ${_SCR} in debug mode":
# echo;
# /home/oracle/scripts/lib/default/_library/libraryctl -d
# echo;
# echo "Executing ${_SCR} in help mode":
# echo;
# /home/oracle/scripts/lib/default/_library/libraryctl -h -v
# echo;
echo "Executing ${_SCR} in debug and configure mode":
/home/oracle/scripts/lib/default/_library/libraryctl -d configure -b "_LIB_TO_LOAD=lib2"
echo;




exit ${?}
