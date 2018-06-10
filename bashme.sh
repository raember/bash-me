#!/bin/sh

## Logging
# http://www.cubicrace.com/2016/03/log-tracing-mechnism-for-shell-scripts.html

log() {
    logmsg="$(date '+%Y-%M-%d %H:%m:%S') $2 $3"
    echo -e "$1$logmsg$font_reset"
    if [ -n "$log2file" && -n "$logfile" ]; then echo "$logmsg" >> $logfile; fi
}
trace() {
    if [ "$loglevel" -gt "$ll_trace" ]; then return; fi
    log "$fg_light_gray" "[TRACE]" "$1"
}
debug() {
    if [ "$loglevel" -gt "$ll_debug" ]; then return; fi
    log "$fg_light_gray" "[DEBUG]" "$1"
}
info() {
    if [ "$loglevel" -gt "$ll_info" ]; then return; fi
    log "$fg_default" "[INFO] " "$1"
}
warn() {
    if [ "$loglevel" -gt "$ll_warn" ]; then return; fi
    log "$fg_yellow" "[WARN] " "$1"
}
error() {
    if [ "$loglevel" -gt "$ll_error" ]; then return; fi
    log "$fg_light_red" "[ERROR]" "$1"
}
fatal() {
    if [ "$loglevel" -gt "$ll_fatal" ]; then return; fi
    log "$fg_red" "[FATAL]" "$1"
}
ll_trace=0
ll_debug=1
ll_info=2
ll_warn=3
ll_error=4
ll_fatal=5
loglevel="$ll_info"
logfile="./$(basename "$0").log"
log2file=


## Exit codes
exit_ok=0
exit_err=1
exit_missuse=2
exit_cannotexec=126
exit_cmdnotfound=127
exit_invalarg=128
exit_fatal_base=128
exit_ctrlc=130
exit_outofrng=255


## Colors and formatting
fg_default="\033[39m"
fg_black="\033[30m"
fg_red="\033[31m"
fg_green="\033[32m"
fg_yellow="\033[33m"
fg_blue="\033[34m"
fg_magenta="\033[35m"
fg_cyan="\033[36m"
fg_light_gray="\033[37m"
fg_dark_gray="\033[90m"
fg_light_red="\033[91m"
fg_light_green="\033[92m"
fg_light_yellow="\033[93m"
fg_light_blue="\033[94m"
fg_light_magenta="\033[95m"
fg_light_cyan="\033[96m"
fg_white="\033[97m"

bg_default="\033[49m"
bg_black="\033[40m"
bg_red="\033[41m"
bg_green="\033[42m"
bg_yellow="\033[43m"
bg_blue="\033[44m"
bg_magenta="\033[45m"
bg_cyan="\033[46m"
bg_light_gray="\033[47m"
bg_dark_gray="\033[100m"
bg_light_red="\033[101m"
bg_light_green="\033[102m"
bg_light_yellow="\033[103m"
bg_light_blue="\033[104m"
bg_light_magenta="\033[105m"
bg_light_cyan="\033[106m"
bg_white="\033[107m"

font_bold="\033[1m"
font_blink="\033[5m"
font_reverse="\033[7m"

font_no_bold="\033[21m"
font_no_blink="\033[25m"
font_no_reverse="\033[27m"

font_reset="\033[0m"



trace "test this"
debug "test this"
info "test this"
warn "test this"
error "test this"
fatal "test this"