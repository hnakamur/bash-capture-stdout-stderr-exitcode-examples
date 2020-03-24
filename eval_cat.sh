#!/bin/bash

mock_curl_v() {
    echo stdout1
    echo stderr1 >&2
    sleep 1
    echo stdout2
    echo stderr2 >&2
    return 3
}

# Capture stdout, stderr, and exit code with https://stackoverflow.com/a/18086548/1391518
unset t_out t_err
eval "$( mock_curl_v \
    2> >(t_err=$(cat); typeset -p t_err) \
    > >(t_out=$(cat); typeset -p t_out); t_ret=$?; typeset -p t_ret )"

echo "t_err=$t_err"
echo "t_out=$t_out"
echo "t_ret=$t_ret"
