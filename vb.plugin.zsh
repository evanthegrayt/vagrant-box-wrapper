source "${0:h}/vb.sh"
source "${0:h}/vb_completion.sh"

_vb() {
    _arguments "1: :($( _vb_vagrant_args ))"
}

compdef '_vb' vb

