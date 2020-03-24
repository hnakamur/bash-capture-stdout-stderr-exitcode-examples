#!/bin/bash

mock_curl_v() {
    echo stdout1
    echo stderr1 >&2
    sleep 1
    echo stdout2
    echo stderr2 >&2
    return 3
}

# capture stdout, stderr, and exit code with https://stackoverflow.com/a/18086548/1391518
rm -f pipeout pipeerr
mkfifo pipeout pipeerr
mock_curl_v >pipeout 2>pipeerr &     # blocks until reader is connected
curl_pid=$!
exec {fdout}<pipeout {fderr}<pipeerr # unblocks `mock_curl_v &`
rm pipeout pipeerr                   # filesystem objects are no longer needed

t_out=$(cat <&$fdout)
t_err=$(cat <&$fderr)
wait $curl_pid
t_ret=$?
exec {fdout}<&- {fderr}<&- # free file descriptors, optional

echo "t_err=$t_err"
echo "t_out=$t_out"
echo "t_ret=$t_ret"
