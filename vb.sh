vb() {
    local b
    local box
    local index
    local desired_box
    local current_box

    local cmd="$1"

    [[ -f $HOME/.vbrc ]] && source $HOME/.vbrc

    if [[ -n $VB_CACHE ]]; then
        if [[ -d $VB_CACHE || $VB_CACHE == */ ]]; then
            VB_CACHE=$VB_CACHE/vb.cache
        fi
    else
        VB_CACHE="${ZSH_CACHE_DIR:-"$HOME/.cache/vb"}/vb.cache"
    fi

    [[ -d ${VB_CACHE%/*} ]] || mkdir -p ${VB_CACHE%/*}

    if ${VB_COLOR:=true}; then
        : ${VB_ERROR_COLOR:='\e[0;91m'}
        : ${VB_SUCCESS_COLOR:='\e[0;92m'}
        : ${VB_WARNING_COLOR:='\e[0;93m'}
        VB_RESET='\e[0m'
    else
        unset VB_ERROR_COLOR VB_SUCCESS_COLOR VB_WARNING_COLOR VB_RESET
    fi

    if [[ -f $VB_CACHE ]]; then
        current_box="$( < $VB_CACHE)"
    else
        printf "${VB_WARNING_COLOR}Box not previously set. "
        printf "Setting to first box in array.\n"
        printf "Use \`vb switch' to change.$VB_RESET\n"
        echo ${VB_BOXES[1]} > $VB_CACHE
        current_box="${VB_BOXES[1]}"
    fi

    if [[ -z $VB_BOXES ]]; then
        printf "${VB_ERROR_COLOR}To use this command, you must set " >&2
        printf "\`VB_BOXES=()' in a startup file, or \`~/.vbrc'$VB_RESET\n" >&2
        return 1
    elif [[ -z $VB_BOXES_LOCATION ]]; then
        printf "${VB_ERROR_COLOR}To use this command, you must set " >&2
        printf "\`VB_BOXES_LOCATION=\"\"' in a startup file, or " >&2
        printf "\`~/.vbrc'$VB_RESET\n" >&2
        return 1
    fi

    local working_dir="$VB_BOXES_LOCATION/$current_box"

    case "$cmd" in
        list)
            for box in "${VB_BOXES[@]}"; do
                if [[ $box == $current_box ]]; then
                    printf "* ${VB_SUCCESS_COLOR}$box$VB_RESET\n"
                else
                    echo "  $box"
                fi
            done
            ;;

        switch)
            index=1

            for b in "${VB_BOXES[@]}"; do
                if [[ $b == $current_box ]]; then
                    if (( $index == ${#VB_BOXES[@]} )); then
                        box=${VB_BOXES[1]}
                        break
                    else
                        box="${VB_BOXES[$(( index + 1 ))]}"
                        break
                    fi
                fi
                (( index++ ))
            done

            echo $box > $VB_CACHE
            printf "Switching to box [${VB_SUCCESS_COLOR}$box$VB_RESET]\n"
            ;;

        cd)
            cd $working_dir
            ;;

        echo)
            echo $working_dir
            ;;

        use)
            box="$2"

            if [[ -z $box ]]; then
                printf "${VB_ERROR_COLOR}No box specified.$VB_RESET\n"
                return 1
            fi

            for b in "${VB_BOXES[@]}"; do
                if [[ $b == $box ]]; then
                    desired_box="$box"
                    break
                fi
            done

            if [[ -z $desired_box ]]; then
                printf "${VB_ERROR_COLOR}[$box] " >&2
                printf "not in \$VB_BOXES$VB_RESET\n" >&2
                return 1
            fi

            if [[ $desired_box == $current_box ]]; then
                printf "${VB_WARNING_COLOR}[$desired_box] "
                printf "is already the current box.$VB_RESET\n"
                return 0
            fi

            echo $desired_box > $VB_CACHE
            printf "Switching to box "
            printf "[${VB_SUCCESS_COLOR}$desired_box$VB_RESET]\n"
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
            [[ $PWD == $working_dir ]] || cd "$working_dir"
            vagrant "$@"
            [[ $PWD == $OLDPWD ]] || cd $OLDPWD
            ;;

    esac
}

__vb_vagrant_args() {
    printf "list\nuse\nswitch\ncd\necho\n"
    vagrant -h | "grep" -E "^\s+" | awk '{print $1}' | tr -d ','
}
