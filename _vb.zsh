#compdef vb

_vb_get_args() {
    vagrant -h | "grep" -E "^\s+" | awk '{print $1}' | tr -d ','
}

_arguments "1: :(list switch list-commands $(_vb_get_args))"

