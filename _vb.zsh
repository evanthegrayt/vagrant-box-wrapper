#compdef vb

_vb_vagrant_args() {
    vagrant -h | "grep" -E "^\s+" | awk '{print $1}' | tr -d ','
}

_arguments "1: :(list switch use list-commands $(_vb_vagrant_args))"

