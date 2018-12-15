## vb [command]
A wrapper plugin for [vagrant](https://www.vagrantup.com/). Allows for calling
`vagrant` commands from outside of the box directory. Also, if the user has
multiple `vagrant` boxes, the `switch` parameter switches which box the command
deals with.

## Installation
I wrote this function as an
[oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh) plugin, but it will work
with vanilla `zsh`, or even [bash-it](https://github.com/Bash-it/bash-it)
or vanilla `bash`.

### oh-my-zsh
Clone the repository in your `$ZSH_CUSTOM/plugins` directory
```sh
git clone https://github.com/evanthegrayt/vb.git $ZSH_CUSTOM/plugins/vb
```
Then add the plugin to your `$HOME/.zshrc` file in the `plugins` array:
```sh
plugins=(vb) # Obviously, leave your other plugins in the array
```

This plugin also supports `zsh` tab-completion.

### bash-it
Clone the repository in your `$BASH_IT_CUSTOM` directory
```sh
git clone https://github.com/evanthegrayt/vb.git $BASH_IT_CUSTOM/vb
```
Files in this directory that end with `.bash` are automatically sourced, so
there's nothing else to do.

### Vanilla zsh or bash
Just source the `vb.plugin.bash` file from one of your startup files, such as
`~/.zshrc` or `~/.bashrc`

## Set-up
To use this feature, you need to either export `VB_BOXES_LOCATION=[dir]` and
`VB_BOXES=([BOX NAMES])` as environmental variables, or create a file called
`$HOME/.vbrc`, and set the variables in that file. `VB_BOX_LOCATION` should be
set to the path where the boxes are located, and `VB_BOXES` should be and array
containing the names of the boxes.

```sh
# ENVIRONMENTAL VARIABLE EXAMPLE; this line would go in .zshrc or some other
# start-up config file
export VB_BOXES_LOCATION="/path/to/where/boxes/are"
export VB_BOXES=(vagrant_box_1 vagrant_box_2)

# RC FILE EXAMPLE; this line would go in `$HOME/.vbrc`
VB_BOXES_LOCATION="/path/to/where/boxes/are"
VB_BOXES=(vagrant_box_1 vagrant_box_2)
```

I chose to allow both methods because some people prefer not to pollute their
environment, and some poeple don't like creating a lot of dotfiles in their home
directory. I prefer to create the files, but feel free to choose the method you
prefer.

## Usage
Currently, this command only comes with two unique commands: `switch` and
`list`. Any other command, `vb` will assume it's a command meant for `vagrant`
and will pass it as an argument to `vagrant`.

