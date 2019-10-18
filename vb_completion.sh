_vb_vagrant_args() {
    echo list use switch
    vagrant -h | "grep" -E "^\s+" | awk '{print $1}' | tr -d ','
}
