## vb [command]
A wrapper plugin for [vagrant](https://www.vagrantup.com/) that  allows for
calling `vagrant` commands from outside of the box directory. Also, if the user
has multiple `vagrant` boxes, the `switch` parameter switches which box the
commands deal with.

![](images/example.jpg)

## Installation
I wrote this function as an
[oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh) plugin, but it will work
with vanilla `zsh`, or even [bash-it](https://github.com/Bash-it/bash-it)
or vanilla `bash`.

### oh-my-zsh
Clone the repository in your `$ZSH_CUSTOM/plugins` directory. Make sure to name
the directory `vb`.
```sh
git clone https://github.com/evanthegrayt/vagrant-box-switcher.git $ZSH_CUSTOM/plugins/vb
```
Then add the plugin to your `$HOME/.zshrc` file in the `plugins` array:
```sh
plugins=(vb) # Obviously, leave your other plugins in the array.
```

This plugin also supports `zsh` tab-completion when using `oh-my-zsh`.

### bash-it
Clone the repository in your `$BASH_IT_CUSTOM` directory.
```sh
git clone https://github.com/evanthegrayt/vb.git $BASH_IT_CUSTOM/vb
```
Files in this directory that end with `.bash` are automatically sourced, so
there's nothing else to do.

### Vanilla zsh or bash
Just source the `vb.plugin.bash` file from one of your startup files, such as
`~/.zshrc` or `~/.bashrc`.

## Usage
To use this function, you need to add `VB_BOXES_LOCATION=[dir]` and
`VB_BOXES=([BOX NAMES])` as variables in either a startup file, or a file named
`$HOME/.vbrc`.

- `VB_BOX_LOCATION` should be a string set to the path where the boxes are
located.
- `VB_BOXES` should be an array, with each element being a *directory*
that contains a vagrant box.

```sh
# These lines should go in either a startup file, such as `~/.zshrc` or
# `~/.bashrc`, or ~/.vbrc.
VB_BOXES_LOCATION="/path/to/where/boxes/are"
VB_BOXES=(vagrant_box_1 vagrant_box_2 vagrant_box_3)
```

Currently, this command only comes with two unique arguments: `switch` and
`list`. Any other argument, `vb` will forward to the `vagrant` command. Use this
feature to run common `vagrant` commands, such as `up` or `ssh`.

