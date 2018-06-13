# bash-me
Trying to make a reusable bash template

## Logging
Logging with the popular log levels is supported as follows:
* `trace` (Logging level 0: `loglevel="$ll_trace"`)
* `debug` (Logging level 1: `loglevel="$ll_debug"`)
* `info`  (Logging level 2: `loglevel="$ll_info"`)
* `warn`  (Logging level 3: `loglevel="$ll_warn"`)
* `error` (Logging level 4: `loglevel="$ll_error"`)
* `fatal` (Logging level 5: `loglevel="$ll_fatal"`)

The default log level is `loglevel=$ll_debug`. The logging can be completely muted by setting the loglevel to 6: `loglevel=$ll_quiet`.

To write the logs to a log file, the variable `log2file` can be set. The logs will then be written to a file with the same name as the executing script file, a ".log" appended.
If desired, the logfile name can be changed via the `logfile` variable.

## Exit codes
Constants for the commonly used exit codes according to [tldp.org](http://www.tldp.org/LDP/abs/html/exitcodes.html#EXITCODESREF "Appendix E. Exit Codes With Special Meanings"):

| Exit Code | Exit Code Number | Meaning | Example | Comments |
| --- | --- | --- | --- | --- |
| `$exit_ok` | `0` | Code exited normally | `echo "Hello world!"` | |
| `$exit_err` | `1` | Catchall for general errors | `let "var1 = 1/0"` | Miscellaneous errors, such as "divide by zero" and other impermissible operations |
| `$exit_missuse` | `2` | Misuse of shell builtins (according to Bash documentation) | `empty_function() {}` | [Missing keyword](http://www.tldp.org/LDP/abs/html/debugging.html#MISSINGKEYWORD) or command, or permission problem (and [diff return code on a failed binary file comparison](http://www.tldp.org/LDP/abs/html/filearchiv.html#DIFFERR2)). |
| `$exit_cannotexec` | `126` | Command invoked cannot execute | `/dev/null` | Permission problem or command is not an executable |
| `$exit_cmdnotfound` | `127` | "command not found" | `illegal_command` | Possible problem with $PATH or a typo |
| `$exit_invalarg` | `128` | Invalid argument to [exit](http://www.tldp.org/LDP/abs/html/exit-status.html#EXITCOMMANDREF) | `exit 3.14159` | **exit** takes only integer args in the range 0 - 255 (see first footnote) |
| `$exit_fatal_base + n` | `128 + n` | Fatal error signal `n` | `kill -9 $PPID of script` | `$?` returns 137 (128 + 9) |
| `$exit_ctrlc` | `130` | Script terminated by Control-C | *Ctl-C* | Control-C is fatal error signal 2, (130 = 128 + 2, see above) |
| `$exit_outofrng` | `255` | Exit status out of range | `exit -1` | **exit** takes only integer args in the range 0 - 255 |

To simplify the checking of the exit codes, the command `check_exit_code $?` can be used, which also logs the result appropriately. It can further be used in if-statements:
```sh
ls /path/to/file/or/dir
if check_exit_code $?; then
    echo "successful execution"
else
    echo "faulty execution"
fi
```
Keep in mind that the checking of positive return values logs messages on the `$ll_warn` level.

## Colors and formatting
To make formatting easier, here are some constants to use while formatting strings:
| Effect | Foreground | Background |
| --- | --- | --- |
| default | `fg_default` | `bg_default` |
| black | `fg_black` | `bg_black` |
| red | `fg_red` | `bg_red` |
| green | `fg_green` | `bg_green` |
| yellow | `fg_yellow` | `bg_yellow` |
| blue | `fg_blue` | `bg_blue` |
| magenta | `fg_magenta` | `bg_magenta` |
| cyan | `fg_cyan` | `bg_cyan` |
| light gray | `fg_light_gray` | `bg_light_gray` |
| dark gray | `fg_dark_gray` | `bg_dark_gray` |
| light red | `fg_light_red` | `bg_light_red` |
| light green | `fg_light_green` | `bg_light_green` |
| light yellow | `fg_light_yellow` | `bg_light_yellow` |
| light blue | `fg_light_blue` | `bg_light_blue` |
| light magenta | `fg_light_magenta` | `bg_light_magenta` |
| light cyan | `fg_light_cyan` | `bg_light_cyan` |
| white | `fg_white` | `bg_white` |
| bold | `fnt_bold`/`fnt_no_bold` ||
| dim | `fnt_dim`/`fnt_no_dim` ||
| italic | `fnt_italic`/`fnt_no_italic` ||
| underline | `fnt_underline`/`fnt_no_underline` ||
| blink | `fnt_blink`/`fnt_no_blink` ||
| overline | `fnt_overline`/`fnt_no_overline` ||
| reverse | `fnt_reverse`/`fnt_no_reverse` ||
| hidden | `fnt_hidden`/`fnt_no_hidden` ||
| strikeout | `fnt_strikeout`/`fnt_no_strikeout` ||
| reset | `fnt_reset` | `fnt_reset` |

Keep in mind that to use those in an `echo` command, the `-e` flag is mandatory.

## Option parsing
To define an option to parse for, the variable `opts` can be set:
```sh
opts=<flags>
```
`flags`: The flags used by getopts to parse the arguments. For example:
```sh
opts="ol:hv"
```
for parsing flags like `-h -l file -o -v`.

By default, the following options are predefined:
* `h`: Show usage and help text.
* `v`: Be verbose(loglevel 0).
* `q`: Be quiet(no logs - overrides `v`).
* `l:`: Loglevel(defaults to `2`(INFO)).
* `o:`: Writes to logfile(defaults to `$(basename $0)` - argument optional).
* `t`: Don't setup signal traps.

The actual parsing of the arguments can be initiated via the `setup "$*"` method.

## Trapping signals
The script predefines traps for all signals defined in [signal.h](http://pubs.opengroup.org/onlinepubs/9699919799/basedefs/signal.h.html):
| Signal | Default behaviour | Description | Command |
| --- | --- | --- | --- |
| EXIT | Terminate | Exit script. | `sig_exit` |
| ERR | Terminate | Error occurred. | `sig_err` |
| DEBUG | Ignore | Debug cmd before every statement. | * |
| RETURN | Ignore | After a function or a script got sourced. | `sig_return` |
| SIGHUP | Terminate | Hangup. | `sig_hup` |
| SIGINT | Terminate | Terminal interrupt signal(Ctrl+C). | `sig_int` |
| SIGQUIT | Terminate (core dump) | Terminal quit signal(Ctrl+\\). | `sig_quit` |
| SIGILL | Terminate (core dump) | Illegal instruction. | `sig_ill` |
| SIGTRAP | Terminate (core dump) | Trace/breakpoint trap. | `sig_trap` |
| SIGABRT | Terminate (core dump) | Process abort signal. | `sig_abrt` |
| SIGBUS | Terminate (core dump) | Access to an undefined portion of a memory object. | `sig_bus` |
| SIGFPE | Terminate (core dump) | Erroneous arithmetic operation. | `sig_fpe` |
| ~~SIGKILL~~ | Terminate | Kill (cannot be caught or ignored). | ~~`sig_kill`~~ |
| SIGUSR1 | Terminate | User-defined signal 1. | `sig_usr1` |
| SIGUSR2 | Terminate | User-defined signal 2. | `sig_usr2` |
| SIGSEGV | Terminate (core dump) | Invalid memory reference. | `sig_segv` |
| SIGPIPE | Terminate | Write on a pipe with no one to read it. | `sig_pipe` |
| SIGALRM, SIGVTALRM, SIGPROF | Terminate | Alarm clock. | `sig_alrm` |
| SIGTERM | Terminate | Termination signal. | `sig_term` |
| SIGSTKFLT | Terminate | Stack fault. | `sig_stkflt` |
| SIGCHLD | Ignore | Child process terminated/interrupted/resumed. | `sig_chld` |
| SIGCONT | Continue | Continue executing, if stopped. | `sig_cont` |
| SIGSTOP, SIGTSTP | Stop | Terminal stop signal(Ctrl+Z). | `sig_stop` |
| SIGTTIN | Stop | Background process attempting read. | `sig_ttin` |
| SIGTTOU | Stop | Background process attempting write. | `sig_ttou` |
| SIGURG | Ignore | High bandwidth data is available at a socket. | `sig_urg` |
| SIGXCPU | Terminate (core dump) | CPU time limit exceeded. | `sig_xcpu` |
| SIGXFSZ | Terminate (core dump) | File size limit exceeded. | `sig_xfsz` |
| SIGWINCH | Ignore | Window change. | `sig_winch` |
| SIGPOLL | Terminate | Pollable event. | `sig_poll` |
| SIGPWR | Ignore | Power failure. | `sig_pwr` |
| SIGSYS | Terminate (core dump) | Bad system call. | `sig_sys` |
| SIGRTMIN+n | Ignore | Real-time signal. n = {0..15} | `sig_rtmin_{0..15}` |
| SIGRTMAX-n | Ignore | Real-time signal. n = {0..14} | `sig_rtmax_{0..14}` |

For a better insight on their meaning, the [wiki](https://en.wikipedia.org/wiki/Signal_(IPC)) is quite helpful with that.

*= To use the DEBUG-pseudo-signal, one has to setup the trap by oneself. Example:
```sh
sig_debug() {
    local -i row="$((${BASH_LINENO[0]} - 3))"
    local text=$(sed "${row}q;d" "$(basename $0)")
    debug "$row: $text"
    read;
}
trap_sig DEBUG ''
```
This displays the the row number and the code on that row which is about to be executed after hitting `[ENTER]`.

To trap those ferocious beasts, edit the `traps` array:
```sh
# Default traps:
traps=(
  ERR
  EXIT
  INT
)

# In your script, either delete
traps=()
# Recreate
traps=(
    USR1
    USR2
)
# Or add new traps:
traps+=(ERR)
```
Keep in mind that trapped signals require a callback function to be defined according to the table above.

To release a trapped signal back into the wilderness, call the `trap_sig` function with the signal to be released and a `"-"` as callback function. For example to release a previously trapped signal, execute:
```sh
trap_sig INT '-'
```