# Function to simplify using two vagrant boxes
# Probably only useful to me...

vb() {
    local box
    local cmd="$1"
    local cache="${ZSH_CACHE_DIR:-"$HOME/.cache/vb"}/vb.cache"
    local current_vagrant_box=$( < $cache )

    [[ -f $HOME/.vbrc ]] && source $HOME/.vbrc

    if [[ -z $VB_BOXES ]]; then
        echo "To use this command, you must \`export VB_BOXES=()'"
        echo "or create ~/.vbrc and set the variables there."
        return 1
    elif [[ -z $VB_BOXES_LOCATION ]]; then
        echo "To use this command, you must \`export VB_BOXES_LOCATION=\"\"'"
        echo "or create ~/.vbrc and set the variables there."
        return 1
    fi

    local working_dir=$VB_BOXES_LOCATION/$current_vagrant_box

    [[ $PWD == $working_dir ]] || cd $working_dir

    case "$cmd" in
        list)
            for box in ${VB_BOXES[@]}; do
                if [[ $box == $current_vagrant_box ]]; then
                    echo "* $box"
                else
                    echo "  $box"
                fi
            done
            ;;
        switch)
            case $current_vagrant_box in
                vagrant-ique)   box=vagrant-dotcom        ;;
                vagrant-dotcom) box=vagrant-ique          ;;
                *)
                    echo "[CURRENT_VAGRANT_BOX] not set!"
                    return
                    ;;
            esac
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

