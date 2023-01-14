#!/usr/bin/env bash
source utils.sh

function next_ver_code() {
    TAG=$(git tag --sort=creatordate | tail -1)
    if [ -z "$TAG" ]; then TAG=0; fi
    echo "NEXT_VER_CODE=$((TAG + 1))" >>"$GITHUB_OUTPUT"
}

function get_output() {
    DELIM="$(openssl rand -hex 8)"
    {
        echo "BUILD_LOG<<${DELIM}"
        cat build.md
        echo "${DELIM}"
    } >>"$GITHUB_OUTPUT"

    cp -f build.md build.tmp

    cd build || exit 1
    yt_op=$(find . -maxdepth 1 -name "youtube-revanced-magisk-*.zip" -printf '%P')
    yt_op=$(echo "$yt_op" | sed "s/youtube-revanced-magisk-//" | sed "s/-all.zip//")
    if [ -z "$yt_op" ]; then
        echo "RELEASE_NAME=ReVanced" >>"$GITHUB_OUTPUT"
    else
        echo "RELEASE_NAME=$yt_op" >>"$GITHUB_OUTPUT"
    fi
}

get_update_json() {
    echo "{
        \"version\": \"$1\",
        \"versionCode\": $2,
        \"zipUrl\": \"$3\",
        \"changelog\": \"https://raw.githubusercontent.com/$GITHUB_REPOSITORY/update/build.md\"
    }"
}

function set_telegram_message() {
    NL=$'\n'
    DELIM="$(openssl rand -hex 8)"
    APKS=""
    MODULES=""
    BODY="$(cat ../build.md | sed 's/\* \*\*/↪ \*\*/g; s/\*\*/\*/g; s/###//g')"
    BODY+="${NL}[Repository]($GITHUB_SERVER_URL/$GITHUB_REPOSITORY/releases)"

    for OUTPUT in *; do
        DL_URL="$GITHUB_SERVER_URL/$GITHUB_REPOSITORY/releases/download/${NEXT_VER_CODE}/${OUTPUT}"
        if [[ $OUTPUT = *.apk ]]; then
            APKS+="${NL}📦[${OUTPUT}](${DL_URL})"
        elif [[ $OUTPUT = *.zip ]]; then
            MODULES+="${NL}📦[${OUTPUT}](${DL_URL})"
        fi
    done

    MICRO_G=$(wget -q -nv -O- https://api.github.com/repos/inotia00/VancedMicroG/releases/latest)
    MICRO_G_URL=$(echo "$MICRO_G" | json_get 'browser_download_url' | grep 'apk')
    APKS+="${NL}📦[Micro-G](${MICRO_G_URL})"

    MODULES=${MODULES#"$NL"}
    APKS=${APKS#"$NL"}

    MSG="*New build!*
*${RELEASE_NAME}*

${BODY}

*⬇️ Download Links:*
Magisk Modules (Root):
${MODULES}

APKs (Non-Root):
${APKS}
"
    {
        echo "TELEGRAM_MSG<<${DELIM}"
        echo "$MSG"
        echo "${DELIM}"
    } >>"$GITHUB_OUTPUT"
}

function update_config() {
    git checkout -f update || git switch --discard-changes --orphan update

    cp -f build.tmp build.md
    cd build || echo "build folder not found"

    for OUTPUT in *revanced*.zip; do
        [ "$OUTPUT" = "*revanced*.zip" ] && continue
        ZIP_S=$(unzip -p "$OUTPUT" module.prop)
        if ! UPDATE_JSON=$(echo "$ZIP_S" | grep updateJson); then
            continue
        fi
        UPDATE_JSON="${UPDATE_JSON##*/}"
        VER=$(echo "$ZIP_S" | grep version=)
        VER="${VER##*=}"
        DLURL="$GITHUB_SERVER_URL/$GITHUB_REPOSITORY/releases/download/$NEXT_VER_CODE/${OUTPUT}"
        get_update_json "$VER" "$NEXT_VER_CODE" "$DLURL" "$CHANGELOG_URL" >"../$UPDATE_JSON"
    done

    set_telegram_message

    cd ..
    find . -name "*-update.json" | grep . || : >dummy.json
}

function telegram_release() {
    echo "$TELEGRAM_MSG"
    POST="https://api.telegram.org/bot${TG_TOKEN}/sendMessage"
    curl -X POST --data-urlencode "parse_mode=Markdown" --data-urlencode "text=${TELEGRAM_MSG}" --data-urlencode "chat_id=${TG_CHAT}" "$POST" >/dev/null
}

function get_var() {
    CASE="$1"
    if [ "$CASE" == "next_ver_code" ]; then
        next_ver_code
    elif [ "$CASE" == "get_output" ]; then
        get_output
    elif [ "$CASE" == "update_config" ]; then
        update_config
    elif [ "$CASE" == "telegram_release" ]; then
        telegram_release
    else
        exit
    fi
}

get_var "$1"
