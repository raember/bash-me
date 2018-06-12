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
The script predefines traps for all signals defined in [signal.h](http://pubs.opengroup.org/onlinepubs/9699919799/basedefs/signal.h.html) and executes a corresponding command:
| Signal | Default behaviour | Description | Command |
| --- | --- | --- | --- |
| EXIT | Terminate | Exit script. | `cleanup` |
| ERR | Terminate | Error occurred. | `err` |
| DEBUG | Ignore | Debug cmd before every statement. | * |
| SIGHUP | Terminate | Hangup. | `hup` |
| SIGINT | Terminate | Terminal interrupt signal(Ctrl+C). | `interrupt` |
| SIGQUIT | Terminate (core dump) | Terminal quit signal(Ctrl+\\). | `quit` |
| SIGILL | Terminate (core dump) | Illegal instruction. | `ill` |
| SIGTRAP | Terminate (core dump) | Trace/breakpoint trap. | `trapped` |
| SIGABRT | Terminate (core dump) | Process abort signal. | `abort` |
| SIGBUS | Terminate (core dump) | Access to an undefined portion of a memory object. | `bus` |
| SIGFPE | Terminate (core dump) | Erroneous arithmetic operation. | `fpe` |
| SIGKILL | Terminate | Kill (cannot be caught or ignored). |  |
| SIGUSR1 | Terminate | User-defined signal 1. | `usr1` |
| SIGUSR2 | Terminate | User-defined signal 2. | `usr2` |
| SIGSEGV | Terminate (core dump) | Invalid memory reference. | `segv` |
| SIGPIPE | Terminate | Write on a pipe with no one to read it. | `pipe` |
| SIGALRM, SIGVTALRM, SIGPROF | Terminate | Alarm clock. | `alarm` |
| SIGTERM | Terminate | Termination signal. | `term` |
| SIGSTKFLT | Terminate | Stack fault. | `stackfault` |
| SIGCHLD | Ignore | Child process terminated/interrupted/resumed. | `child` |
| SIGCONT | Continue | Continue executing, if stopped. | `cont` |
| SIGSTOP, SIGTSTP | Stop | Terminal stop signal(Ctrl+Z). | `stop` |
| SIGTTIN | Stop | Background process attempting read. | `ttyin` |
| SIGTTOU | Stop | Background process attempting write. | `ttyout` |
| SIGURG | Ignore | High bandwidth data is available at a socket. | `urgent` |
| SIGXCPU | Terminate (core dump) | CPU time limit exceeded. | `xcpu` |
| SIGXFSZ | Terminate (core dump) | File size limit exceeded. | `xfsz` |
| SIGWINCH | Ignore | Window change. | `window_change` |
| SIGPOLL | Terminate | Pollable event. |  |
| SIGPWR | Ignore | Power failure. | `power_fail` |
| SIGSYS | Terminate (core dump) | Bad system call. | `syserror` |
| SIGRTMIN+n | Ignore | Real-time signal. n = {0..15} | `rtmin{0..15}` |
| SIGRTMAX-n | Ignore | Real-time signal. n = {0..14} | `rtmax{0..14}` |

For a better insight on their meaning, the [wiki](https://en.wikipedia.org/wiki/Signal_(IPC)) is quite helpful with that.

*= To use the DEBUG-pseudo-signal, one has to setup the trap by oneself. Example:
```sh
trap 'debug_pre ${LINENO}' DEBUG
debug_pre() {
    debug "debugging ($1)."
    read;
}
```