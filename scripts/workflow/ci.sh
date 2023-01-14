#!/usr/bin/env bash
source utils.sh
toml_prep "$(cat config.toml)"

# Should Build Helpers
function is_youtube_latest() {
    v=$(toml_get "$(toml_get_table "YouTube")" "version")
    if [ "$v" = latest ]; then
        declare -r cur_yt=$(sed -n 's/.*YouTube: \(.*\)/\1/p' build.md | xargs)
        [ -z "$cur_yt" ] && return 1 # empty, fail=>dont build
        declare -r last_ver=$(get_apk_vers "https://www.apkmirror.com/uploads/?appcategory=youtube" | get_largest_ver)

        echo "Current yt version: $cur_yt"
        echo "Latest yt version: $last_ver"
        [ "$cur_yt" != "$last_ver" ] # test success=>build, fail=>dont build
    else
        return 1 # not experimental, dont build
    fi
}
function is_patches_latest() {
    declare -r last_patches_url=$(wget -q -nv -O- https://api.github.com/repos/"${ORG}"/revanced-patches/releases/latest | json_get 'browser_download_url' | grep 'jar')
    declare -r last_patches=${last_patches_url##*/}
    cur_patches=$(sed -n 's/.*Patches: \(.*\)/\1/p' build.md | xargs)

    echo "current patches version: $cur_patches"
    echo "latest patches version: $last_patches"
    [ "$cur_patches" != "$last_patches" ] # test success=>build, fail=>dont build
}

function should_build() {
    if ! git checkout update; then
        echo "first time building!"
        echo "SHOULD_BUILD=1" >>"$GITHUB_OUTPUT"
    elif is_patches_latest || is_youtube_latest; then
        echo "build!"
        echo "SHOULD_BUILD=1" >>"$GITHUB_OUTPUT"
    else
        echo "dont build!"
        echo "SHOULD_BUILD=0" >>"$GITHUB_OUTPUT"
    fi
}

#send_telegram_failure
function send_telegram_failure() {
    ERRORS=$(<errors.log)
    POST="https://api.telegram.org/bot${TG_TOKEN}/sendMessage"
    URL="[Failed Action]($GITHUB_SERVER_URL/$GITHUB_REPOSITORY/actions/runs/$GITHUB_RUN_ID)"

    MSG="*Check patches config*

*LOG*
${ERRORS}
    
${URL}"

    curl -X POST --data-urlencode "parse_mode=Markdown" --data-urlencode "text=${MSG}" --data-urlencode "chat_id=${TG_DEV}" "$POST" >/dev/null
    echo "SHOULD_BUILD=0" >>$GITHUB_OUTPUT
}

function get_var() {
    CASE="$1"
    if [ "$CASE" == "should_build" ]; then
        should_build
    elif [ "$CASE" == "send_telegram_failure" ]; then
        send_telegram_failure
    else
        exit
    fi
}

get_var "$1"
