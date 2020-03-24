#!/bin/bash

mock_curl_v() {
    echo stdout1
    echo stderr1 >&2
    sleep 1
    echo stdout2
    echo stderr2 >&2
    return 3
}

# SYNTAX:
#   catch STDOUT_VARIABLE STDERR_VARIABLE COMMAND
#
# NOTE: This function uses NUL '\0' character as delimiter,
#       and all NUL '\0' characters from stdout and stderr
#       will be deleted.
#       Do not use this function for binary output.
#
# Copied from https://stackoverflow.com/a/59592881/1391518
catch() {
    {
        IFS=$'\n' read -r -d '' "${1}";
        IFS=$'\n' read -r -d '' "${2}";
        (IFS=$'\n' read -r -d '' _ERRNO_; return ${_ERRNO_});
    } < <((printf '\0%s\0%d\0' "$(((({ ${3}; echo "${?}" 1>&3-; } | tr -d '\0' 1>&4-) 4>&2- 2>&1- | tr -d '\0' 1>&4-) 3>&1- | exit "$(cat)") 4>&1-)" "${?}" 1>&2) 2>&1)
}

catch t_out t_err mock_curl_v
t_ret=$?

echo "t_err=$t_err"
echo "t_out=$t_out"
echo "t_ret=$t_ret"
