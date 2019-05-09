# Function to simplify using two vagrant boxes
# Probably only useful to me...

vb() {
    local index
    local b
    local box
    local cmd="$1"
    local cache="${ZSH_CACHE_DIR:-"$HOME/.cache/vb"}/vb.cache"
    local current_vagrant_box=$( < $cache )

    if [[ -z $current_vagrant_box ]]; then
        echo "Box not previously set. Setting to first box in array."
        echo ${VB_BOXES[1]} > $cache
    fi

    [[ -f $HOME/.vbrc ]] && source $HOME/.vbrc

    if [[ -z $VB_BOXES ]]; then
        echo "To use this command, you must set \`VB_BOXES=()'" >&2
        echo "in a startup file, or \`~/.vbrc'" >&2
        return 1
    elif [[ -z $VB_BOXES_LOCATION ]]; then
        echo "To use this command, you must set \`VB_BOXES_LOCATION=\"\"'" >&2
        echo "in a startup file, or \`~/.vbrc'" >&2
        return 1
    fi

    local working_dir=$VB_BOXES_LOCATION/$current_vagrant_box

    [[ $PWD == $working_dir ]] || cd $working_dir

    case "$cmd" in
        list)
            for box in "${VB_BOXES[@]}"; do
                if [[ $box == $current_vagrant_box ]]; then
                    echo "* $box"
                else
                    echo "  $box"
                fi
            done
            ;;
        switch)
            index=1
            for b in "${VB_BOXES[@]}"; do
                if [[ "$b" == $current_vagrant_box ]]; then
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
            [[ -d ${cache%/*} ]] || mkdir -p ${cache%/*}
            echo $box > $cache
            echo "Switching to box [$box]"
            ;;
        -h)
            echo 'USAGE: vb [option]'
            echo
            echo 'vb options:'
            echo '  list:   list available boxes, and show current box'
            echo '  switch: switch which vagrant box the vb command handles'
            echo
            echo "For vagrant help, run with '--help' or 'list-commands'"
            ;;
        *)
            vagrant "$@"
            ;;
    esac

    [[ $PWD == $OLDPWD ]] || cd $OLDPWD
}

