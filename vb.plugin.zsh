source "${0:h}/vb.sh"

_vb() {
    local -a matches

    if [[ $CURRENT -eq 3 && ${words[2]} == use ]]; then
        matches=("${(@f)$(__vb_box_names)}")
    else
        matches=("${(@f)$(__vb_vagrant_args)}")
    fi

    compadd -- "$matches[@]"
}

compdef '_vb' vb
