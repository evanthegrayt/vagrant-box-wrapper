__vb_box_paths() {
    local box_path
    local paths="${VB_BOXES:-}"

    while [[ -n $paths ]]; do
        if [[ $paths == *:* ]]; then
            box_path="${paths%%:*}"
            paths="${paths#*:}"
        else
            box_path="$paths"
            paths=''
        fi

        [[ -n $box_path ]] && printf '%s\n' "$box_path"
    done
}

__vb_box_name() {
    local box_path="${1%/}"

    printf '%s\n' "${box_path##*/}"
}

__vb_box_names() {
    local box_path

    __vb_box_paths | while IFS= read -r box_path; do
        __vb_box_name "$box_path"
    done
}

__vb_first_box_name() {
    local box_path

    while IFS= read -r box_path; do
        __vb_box_name "$box_path"
        return 0
    done < <(__vb_box_paths)

    return 1
}

__vb_duplicate_box_name() {
    local name
    local newline=$'\n'
    local seen="$newline"

    while IFS= read -r name; do
        if [[ $seen == *"${newline}${name}${newline}"* ]]; then
            printf '%s\n' "$name"
            return 0
        fi

        seen="${seen}${name}${newline}"
    done < <(__vb_box_names)

    return 1
}

__vb_box_path_for_name() {
    local desired_name="$1"
    local box_path
    local name
    local match=''
    local matches=0

    while IFS= read -r box_path; do
        name="$(__vb_box_name "$box_path")"

        if [[ $name == "$desired_name" ]]; then
            match="$box_path"
            (( matches++ ))
        fi
    done < <(__vb_box_paths)

    if (( matches == 1 )); then
        printf '%s\n' "$match"
        return 0
    elif (( matches > 1 )); then
        return 2
    fi

    return 1
}

__vb_require_config() {
    local duplicate

    if [[ -z ${VB_BOXES:-} ]]; then
        printf "${VB_ERROR_COLOR}To use this command, set " >&2
        printf "\`export VB_BOXES=\"/path/to/box1:/path/to/box2\"' " >&2
        printf "in your shell init file.$VB_RESET\n" >&2
        return 1
    fi

    if ! __vb_first_box_name >/dev/null; then
        printf "${VB_ERROR_COLOR}VB_BOXES does not contain any box paths." >&2
        printf "$VB_RESET\n" >&2
        return 1
    fi

    if duplicate="$(__vb_duplicate_box_name)"; then
        printf "${VB_ERROR_COLOR}Duplicate box name [$duplicate] in " >&2
        printf "\$VB_BOXES. Box directory names must be unique.$VB_RESET\n" >&2
        return 1
    fi
}

__vb_current_box() {
    local current_box
    local first_box

    if [[ -f $VB_CACHE ]]; then
        current_box="$(< "$VB_CACHE")"

        if __vb_box_path_for_name "$current_box" >/dev/null; then
            printf '%s\n' "$current_box"
            return 0
        fi

        printf "${VB_WARNING_COLOR}Cached box [$current_box] is not in " >&2
        printf "\$VB_BOXES. " >&2
    else
        printf "${VB_WARNING_COLOR}Box not previously set. " >&2
    fi

    first_box="$(__vb_first_box_name)" || return 1
    printf "Setting to first configured box.\n" >&2
    printf "Use \`vb switch' to change.$VB_RESET\n" >&2
    printf '%s\n' "$first_box" > "$VB_CACHE"
    printf '%s\n' "$first_box"
}

vb() {
    local box
    local current_box
    local desired_box
    local next_box
    local box_path
    local seen_current=false
    local working_dir

    local cmd="$1"
    local subcmd="$2"

    __vb_require_config || return 1

    current_box="$(__vb_current_box)" || return 1
    working_dir="$(__vb_box_path_for_name "$current_box")" || return 1

    case "$cmd" in
        list)
            while IFS= read -r box_path; do
                box="$(__vb_box_name "$box_path")"

                if [[ $box == "$current_box" ]]; then
                    printf "* ${VB_SUCCESS_COLOR}%s$VB_RESET\n" "$box"
                else
                    printf "  %s\n" "$box"
                fi
            done < <(__vb_box_paths)
            ;;

        switch)
            while IFS= read -r box_path; do
                box="$(__vb_box_name "$box_path")"

                if $seen_current; then
                    next_box="$box"
                    break
                fi

                if [[ $box == "$current_box" ]]; then
                    seen_current=true
                fi
            done < <(__vb_box_paths)

            if [[ -z $next_box ]]; then
                next_box="$(__vb_first_box_name)" || return 1
            fi

            printf '%s\n' "$next_box" > "$VB_CACHE"
            printf "Switching to box [${VB_SUCCESS_COLOR}%s$VB_RESET]\n" "$next_box"
            ;;

        cd)
            cd "$working_dir" || return 1

            if [[ -n $subcmd ]]; then
                if [[ -d $subcmd ]]; then
                    cd "$subcmd" || return 1
                else
                    printf "Subdir [$VB_ERROR_COLOR%s$VB_RESET] " "$subcmd" >&2
                    printf "doesn't exist.\n" >&2
                    return 1
                fi
            fi
            ;;

        echo)
            printf '%s\n' "$working_dir"
            ;;

        use)
            box="$subcmd"

            if [[ -z $box ]]; then
                printf "${VB_ERROR_COLOR}No box specified.$VB_RESET\n" >&2
                return 1
            fi

            desired_box="$(__vb_box_path_for_name "$box")"
            case $? in
                0)
                    ;;
                2)
                    printf "${VB_ERROR_COLOR}[$box] matches more than one " >&2
                    printf "path in \$VB_BOXES.$VB_RESET\n" >&2
                    return 1
                    ;;
                *)
                    printf "${VB_ERROR_COLOR}[$box] " >&2
                    printf "not in \$VB_BOXES$VB_RESET\n" >&2
                    return 1
                    ;;
            esac

            desired_box="$(__vb_box_name "$desired_box")"

            if [[ $desired_box == "$current_box" ]]; then
                printf "${VB_WARNING_COLOR}[%s] " "$desired_box"
                printf "is already the current box.$VB_RESET\n"
                return 0
            fi

            printf '%s\n' "$desired_box" > "$VB_CACHE"
            printf "Switching to box "
            printf "[${VB_SUCCESS_COLOR}%s$VB_RESET]\n" "$desired_box"
            ;;

        -h|'')
            printf "${VB_SUCCESS_COLOR}USAGE: vb [option]$VB_RESET\n"
            echo
            printf "${VB_SUCCESS_COLOR}vb options$VB_RESET\n"
            printf "  ${VB_WARNING_COLOR}list$VB_RESET      | "
            printf "list available boxes, and show current box\n"
            printf "  ${VB_WARNING_COLOR}switch$VB_RESET    | "
            printf "switch which vagrant box the vb command handles\n"
            printf "  ${VB_WARNING_COLOR}use [BOX]$VB_RESET | "
            printf "switch to the specified box\n"
            printf "  ${VB_WARNING_COLOR}cd$VB_RESET        | "
            printf "cd to the box directory\n"
            printf "  ${VB_WARNING_COLOR}echo$VB_RESET      | "
            printf "echo the path of the current box\n"
            echo
            printf "For ${VB_SUCCESS_COLOR}vagrant$VB_RESET help, "
            printf "run with '${VB_WARNING_COLOR}--help$VB_RESET' "
            printf "or '${VB_WARNING_COLOR}list-commands$VB_RESET'\n"
            ;;

        *)
            local oldpwd="$PWD"
            local vagrant_status

            cd "$working_dir" || return 1
            vagrant "$@"
            vagrant_status=$?
            cd "$oldpwd" || return 1

            return "$vagrant_status"
            ;;
    esac
}

__vb_vagrant_args() {
    printf "list\nuse\nswitch\ncd\necho\n"

    if command -v vagrant >/dev/null 2>&1; then
        vagrant -h | grep -E "^[[:space:]]+" | awk '{print $1}' | tr -d ','
    fi
}

if [[ -n ${VB_CACHE:-} ]]; then
    if [[ -d $VB_CACHE || $VB_CACHE == */ ]]; then
        VB_CACHE=$VB_CACHE/vb.cache
    fi
else
    VB_CACHE="${ZSH_CACHE_DIR:-"$HOME/.cache/vb"}/vb.cache"
fi

__vb_cache_dir="${VB_CACHE%/*}"
if [[ $__vb_cache_dir != "$VB_CACHE" ]]; then
    [[ -d $__vb_cache_dir ]] || mkdir -p "$__vb_cache_dir"
fi
unset __vb_cache_dir

if ${VB_COLOR:=true}; then
    : ${VB_ERROR_COLOR:='\e[0;91m'}
    : ${VB_SUCCESS_COLOR:='\e[0;92m'}
    : ${VB_WARNING_COLOR:='\e[0;93m'}
    VB_RESET='\e[0m'
else
    unset VB_ERROR_COLOR VB_SUCCESS_COLOR VB_WARNING_COLOR VB_RESET
fi
