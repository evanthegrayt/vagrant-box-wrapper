DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source $DIR/vb.sh
unset DIR

if [[ -n $BASH_IT ]]; then
    cite about-plugin
    about-plugin 'Manage your vagrant box(es) more easily'
fi

complete -W "$( __vb_vagrant_args )" vb
