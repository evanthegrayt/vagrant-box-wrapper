source "${0:h}/vb.sh"

_vb() {
    _arguments "1: :($( __vb_vagrant_args ))"
}

compdef '_vb' vb

