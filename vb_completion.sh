_vb_vagrant_args() {
    printf "list\nuse\nswitch\ncd\necho"
    vagrant -h | "grep" -E "^\s+" | awk '{print $1}' | tr -d ','
}
