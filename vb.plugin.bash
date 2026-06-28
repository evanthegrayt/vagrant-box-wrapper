DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source "$DIR/vb.sh"
unset DIR

if [[ -n $BASH_IT ]]; then
    cite about-plugin
    about-plugin 'Manage your vagrant box(es) more easily'
fi

_vb_complete() {
    local cur="${COMP_WORDS[COMP_CWORD]}"
    local prev="${COMP_WORDS[COMP_CWORD - 1]}"

    if [[ $COMP_CWORD -eq 2 && $prev == use ]]; then
        COMPREPLY=( $(compgen -W "$(__vb_box_names)" -- "$cur") )
    else
        COMPREPLY=( $(compgen -W "$(__vb_vagrant_args)" -- "$cur") )
    fi
}

complete -F _vb_complete vb
