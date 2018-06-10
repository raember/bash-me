# bash-me
Trying to make a reusable bash template

## Logging
Logging with the popular log levels is supported as follows:
* `trace` (Logging level 0: `loglevel="$ll_trace"`)
* `debug` (Logging level 1: `loglevel="$ll_debug"`)
* `info` (Logging level 2: `loglevel="$ll_info"`)
* `warn` (Logging level 3: `loglevel="$ll_warn"`)
* `error` (Logging level 4: `loglevel="$ll_error"`)
* `fatal` (Logging level 5: `loglevel="$ll_fatal"`)

The default log level is `$ll_debug`.
To write the logs to a log file, the variable `log2file` can be set. The logs will then be written to a file with the same name as the executing script file, a ".log" appended.
If desired, the logfile name can be changed via the `logfile` variable.

## Exit codes
Constants for the commonly used exit codes according to [tldp.org]http://www.tldp.org/LDP/abs/html/exitcodes.html#EXITCODESREF "Appendix E. Exit Codes With Special Meanings"):

| Exit Code | Exit Code Number | Meaning | Example | Comments |
| --- | --- | --- | --- | --- |
| `$exit_ok` | `1`