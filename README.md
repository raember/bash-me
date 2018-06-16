# Bash-me
Bash-me is a script providing basic functionality for extended bash scripts.

### Example
Here is an example of how to use the script:
```sh
# Source the script
. bashme

# Basic settings
loglevel=$LL_INFO

# Setup:
PROGRAM_NAME="${BOLD}Bash me${RESET}"
VERSION="${FG_GREEN}v0.1${RESET}"
YEAR=2018
FULL_NAME="Raphael Emberger"
LICENCE="MIT License

Copyright (c) $YEAR $FULL_NAME

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the \"Software\"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE."
EXPLANATION='Provides nice features for bash scripting.'
USAGE=(
  '[OPTION]...    Execute script with arguments.'
  '               Show this help page.'
)
define_opt '_log'  '-l' ''         'n'    "Log level ${ITALIC}n${RESET}."
define_opt '_help' '-h' '--help'   ''     'Display this help text.'
define_opt '_ver'  '-v' ''         ''     'Display the VERSION.'
define_opt '_file' ''   '--output' 'file' "Write log to ${ITALIC}file${RESET}(defaults to $logfile)."
DESCRIPTION="
This is an example configuration to use the Bash-me script.
You can add a licence if you want."

# Parse arguments
parse_args "$@"

# Process options
[[ -n "$_help" ]] || [[ -z ${BASH_ARGC[@]} ]] && print_usage && exit
[[ -n "$_log" ]] && loglevel="$_log"
[[ -n "$_ver" ]] && print_version && exit
[[ -n "$_file" ]] && logfile="$_file"
[[ -n "${args[@]}" ]] && IFS=";" && info "Provided additional arguments: '${args[*]}'"

# Setup traps
sig_err() {
  error "Well, I guess something went wrong."
  exit;
}
sig_int() {
  error "Bye bye."
  exit;
}
trap_signals

# ... Code ...
```

## Logging
Logging with the popular log levels is supported as follows:
* `trace` (Logging level 0: `loglevel=$LL_TRACE`)
* `debug` (Logging level 1: `loglevel=$LL_DEBUG`)
* `info`  (Logging level 2: `loglevel=$LL_INFO`)
* `warn`  (Logging level 3: `loglevel=$LL_WARN`)
* `error` (Logging level 4: `loglevel=$LL_ERROR`)
* `fatal` (Logging level 5: `loglevel=$LL_FATAL`)

The default log level is `loglevel=$LL_INFO`. The logging can be completely muted by setting the loglevel to `$LL_QUIET`.

To write the logs to a log file, the variable `log2file` can be set. The logs will then be written to a file with the same name as the executing script file, a ".log" appended.
If desired, the logfile name can be changed via the `logfile` variable.

To disable logging to `stdout`/`stderr`, the variable `log2std` can be cleared.

To further improve writing scripts, there are 2 additional commands:
* `NYI`: Serves as an exit point for code that has **n**ot **y**et been **i**mpemented. Logs on the `LL_WARN` level.
* `TODO`: Marks a point in the code as a TODO. Logs on the `LL_INFO` level.

## Return values
Constants for the commonly used exit codes according to [tldp.org](http://www.tldp.org/LDP/abs/html/exitcodes.html#EXITCODESREF "Appendix E. Exit Codes With Special Meanings"):

| Exit Code | Exit Code Number | Meaning | Example | Comments |
| --- | --- | --- | --- | --- |
| `$EX_OK` | `0` | Code exited normally | `echo "Hello world!"` | |
| `$EX_ERR` | `1` | Catchall for general errors | `let "var1 = 1/0"` | Miscellaneous errors, such as "divide by zero" and other impermissible operations |
| `$EX_MISSUSE` | `2` | Misuse of shell builtins (according to Bash documentation) | `empty_function() {}` | [Missing keyword](http://www.tldp.org/LDP/abs/html/debugging.html#MISSINGKEYWORD) or command, or permission problem (and [diff return code on a failed binary file comparison](http://www.tldp.org/LDP/abs/html/filearchiv.html#DIFFERR2)). |
| `$EX_CANNOTEXEC` | `126` | Command invoked cannot execute | `/dev/null` | Permission problem or command is not an executable |
| `$EX_CMDNOTFOUND` | `127` | "command not found" | `illegal_command` | Possible problem with $PATH or a typo |
| `$EX_INVALARG` | `128` | Invalid argument to [exit](http://www.tldp.org/LDP/abs/html/exit-status.html#EXITCOMMANDREF) | `exit 3.14159` | **exit** takes only integer args in the range 0 - 255 (see first footnote) |
| `$EX_FATAL_BASE + n` | `128 + n` | Fatal error signal `n` | `kill -9 $PPID of script` | `$?` returns 137 (128 + 9) |
| `$EX_INT` | `130` | Command terminated by Control-C | *Ctl-C* | Control-C is fatal error signal 2, (130 = 128 + 2, see above) |
| `$EX_OUTOFRANGE` | `255` | Exit status out of range | `exit -1` | **exit** takes only integer args in the range 0 - 255 |

To simplify the checking of the exit codes, the command `check_exit_code $?` can be used, which also logs the result appropriately. It can further be used in if-statements:
```sh
ls /path/to/file/or/dir
if check_exit_code $?; then
    echo "successful execution"
else
    echo "faulty execution"
fi
```
Or one could use the `case` clause to further evaluate the return value.

Keep in mind that the checking of unknown return values logs messages on the `$LL_WARN` level.

## Colors and formatting
To make formatting easier, here are some constants to use while formatting strings:

| Effect | Foreground | Background |
| --- | --- | --- |
| black | `FG_BLACK` | `BG_BLACK` |
| red | `FG_RED` | `BG_RED` |
| green | `FG_GREEN` | `BG_GREEN` |
| yellow | `FG_YELLOW` | `BG_YELLOW` |
| blue | `FG_BLUE` | `BG_BLUE` |
| magenta | `FG_MAGENTA` | `BG_MAGENTA` |
| cyan | `FG_CYAN` | `BG_CYAN` |
| light gray | `FG_LGRAY` | `BG_LGRAY` |
| dark gray | `FG_GRAY` | `BG_GRAY` |
| light red | `FG_LRED` | `BG_LRED` |
| light green | `FG_LGREEN` | `BG_LGREEN` |
| light yellow | `FG_LYELLOW` | `BG_LYELLOW` |
| light blue | `FG_LBLUE` | `BG_LBLUE` |
| light magenta | `FG_LMAGENTA` | `BG_LMAGENTA` |
| light cyan | `FG_LCYAN` | `BG_LCYAN` |
| white | `FG_WHITE` | `BG_WHITE` |
| bold | `BOLD` ||
| dim | `DIM` ||
| italic | `ITALIC` ||
| standout | `STANDOUT`/`STANDOUT_STOP` ||
| underline | `UNDERLINE`/`UNDERLINE_STOP` ||
| blink | `BLINK` ||
| reverse | `REVERSE` ||
| invisible | `INVISIBLE` ||
| strikeout | `STRIKEOUT` ||
| reset | `RESET` | `RESET` |

Keep in mind that to use those in an `echo` command, the `-e` flag is mandatory.

To test the available formatting capabilities, test them with the following commands:
* `formatting_test`: Writes a table with all the available formattings.
* `color_test`: Writes a table with all the available colors.

## Trapping signals
The script predefines traps for all signals defined in [signal.h](http://pubs.opengroup.org/onlinepubs/9699919799/basedefs/signal.h.html):

| Signal | Default behaviour | Description | Command |
| --- | --- | --- | --- |
| EXIT | Terminate | Exit script. | `sig_exit` |
| ERR | Terminate | Error occurred. | `sig_err` |
| DEBUG | Ignore | Debug cmd before every statement. | `sig_debug` |
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

Example method for debug trap callback:
```sh
sig_debug() {
  local -i row="$((${BASH_LINENO[0]} - 3))"
  local text=$(sed "${row}q;d" "$(basename $0)")
  debug "Next: ($row) $text"
  read
  while : ; do
    local answer
    read -e answer
    [[ -z $answer ]] && break
    history -s "$answer"
    eval "$answer"
  done
}
```
This displays the the row number and the code on that row which is about to be executed after hitting `[ENTER]`.

To mark signals for future trapping, edit the `traps` array:
```sh
# Default traps:
traps=(
  ERR
  INT
)

# In the script, either delete
traps=()
# Recreate
traps=(
    USR1
    SIGUSR2
)
# Or add new traps:
traps+=(EXIT)
```
Keep in mind that trapped signals require a callback function to be defined according to the table above.

If a signal should be trapped which hasn't been defined in the table above, it still tries to trap it.

After that, call the `trap_signals` function to trap those ferocious beasts.

To release a trapped signal back into the wilderness, call the `trap_sig` function with the signal to be released and a `"-"` as callback function. For example to release a previously trapped signal, execute:
```sh
trap_sig INT '-'
```

## Option parsing
To define an option, use the `define_opt` command:
```sh
#          variable shrt long       argument description
define_opt '_log'   '-l' ''         'n'      'Log level n.'
define_opt '_help'  '-h' '--help'   ''       'Display this help text.'
define_opt '_ver'   '-v' ''         ''       'Display the VERSION.'
define_opt '_file'  ''   '--output' 'file'   "Write log to file(defaults to $logfile)."
```
One can also use options such as `+test`.

The description of the option can be formatted.

The remaining, plain arguments parsed can be found in the `args`-array.

To parse options, run the `parse_args` command with the `getopts`-argument. Example:
```sh
# Parses the argument list for h-, f-(with argument) and l-flags:
parse_args "$@"
```
After this, the binary options have a `true` in their variable, whereas others have the value of the argument to that option.

## General info
The following variables can be set on script startup to define the parameters for the help page and the version page:
* `PROGRAM_NAME`: The name of the program. Can be formatted.
* `VERSION`: The current version of the program. Can be formatted.
* `YEAR`: The year when the program has been written.
* `FULL_NAME`: The full name of the author.
* `LICENCE`: The licence text to display. Can be formatted.
* `EXPLANATION`: The use of the program. Can be formatted.
* `USAGE`: The allowed syntaxes to call the program. Can be formatted.
* `DESCRIPTION`: Additional remarks for the end of the help text. Can be formatted.

## Data types
### Stack
To declare a stack variable, the `declare_stack` function can be used. It allocates an array to the stack variable and declares a stack pointer(the variable has the suffix `_i` and should not be altered). Now, the following functions can be used on that stack variable:
* `push <stack> <value>`: Push a value to the stack.
* `pop <stack> <variable>`: Pop a value from the stack. Returns `EX_ERR` if the stack is empty.
* `peek <stack> <variable>`: Peek a value from the stack. Returns `EX_ERR` if the stack is empty.