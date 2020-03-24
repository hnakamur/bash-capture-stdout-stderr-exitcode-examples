#!/bin/bash

mock_curl_v() {
    echo stdout1
    echo stderr1 >&2
    sleep 1
    echo 'stdout2  with two spaces'
    echo 'stderr2  with two spaces'>&2
    return 3
}

# Capture stdout, stderr, and exit code with https://stackoverflow.com/a/18086548/1391518
unset t_out t_err
eval "$( mock_curl_v \
    2> >(readarray -t t_err; typeset -p t_err) \
    > >(readarray -t t_out; typeset -p t_out); t_ret=$?; typeset -p t_ret  )"

# Print stderr array with https://stackoverflow.com/a/15692004/1391518
printf 't_err='
printf '%s\n' "${t_err[@]}"

# Print stdout array with https://stackoverflow.com/a/15692058/1391518
( IFS=$'\n'; echo t_out="${t_out[*]}" )

echo t_ret=$t_ret
