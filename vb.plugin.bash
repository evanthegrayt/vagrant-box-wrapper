DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source $DIR/vb.sh
source $DIR/vb_completion.sh
unset DIR

if [[ -n $BASH_IT ]]; then
    cite about-plugin
    about-plugin 'Manage your vagrant box(es) more easily'
fi

complete -W "$( _vb_vagrant_args )" vb
