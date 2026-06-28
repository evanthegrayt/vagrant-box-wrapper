# Vagrant Box Wrapper
A wrapper plugin for [vagrant](https://www.vagrantup.com/) that allows for
calling `vagrant` commands from outside of the box directory. The plugin also
ships with a few extra commands that help to manage more than one box, along
with custom tab-completion for both `zsh` and `bash`.

View on [GitHub](https://github.com/evanthegrayt/vagrant-box-wrapper) |
[GitHub Pages](https://evanthegrayt.github.io/vagrant-box-wrapper/)

## Screenshot Example
This program's purpose is best explained with a screenshot. Notice, I'm running
the commands from within my home directory, which is *not* where my vagrant box
directories are located.

![](https://github.com/evanthegrayt/vagrant-box-wrapper/releases/download/v2.0.0/vb-screenshot.png)

## Installation
### Vanilla zsh or bash
Clone the repository wherever you like, and source either the `vb.plugin.zsh`
file for `zsh`, or `vb.plugin.bash` file for `bash`, from one of your startup
files, such as `~/.zshrc` or `~/.bashrc`, respectively.

```sh
# Where $INSTALLATION_PATH is the path to where you installed the plugin.
source "$INSTALLATION_PATH/vb.plugin.zsh"  # in ~/.zshrc
source "$INSTALLATION_PATH/vb.plugin.bash" # in ~/.bashrc
```

If you're using a version of `zsh`/`bash` that doesn't support the completion
features, or you just don't want to use them, just source the `vb.sh` file
directly.

```sh
source "$INSTALLATION_PATH/vb.sh" # in either ~/.zshrc or ~/.bashrc
```

Or use your favorite package manager and follow its instructions.

### oh-my-zsh
Clone the repository in your `$ZSH_CUSTOM/plugins` directory. The directory name
needs to be `vb`, so clone it as such.

```sh
git clone https://github.com/evanthegrayt/vagrant-box-wrapper.git \
  $ZSH_CUSTOM/plugins/vb
```

Then add the plugin to the `plugins` array in your `$HOME/.zshrc` file:

```sh
plugins=(vb) # Leave your other plugins in the array.
```

### bash-it
Clone the repository in your `$BASH_IT_CUSTOM` directory.

```sh
git clone https://github.com/evanthegrayt/vagrant-box-wrapper.git \
  $BASH_IT_CUSTOM/vb
```

Files in this directory that end with `.bash` are automatically sourced, so
there's nothing else to do.

## Setup
Set `VB_BOXES` in your shell init file, such as `~/.zshrc`, `~/.bashrc`, or
another file that your shell init file already sources.

`VB_BOXES` is a colon-delimited string of full paths to your vagrant box
directories. It works like `PATH`, so it can be exported and reused by other
scripts.

```sh
# In ~/.zshrc, ~/.bashrc, or another file sourced by your shell init file.
export VB_BOXES="/full/path/to/vb_box1:/another/path/to/vb_box2"
```

Each configured path should point directly at a directory that contains a
vagrant box. The box name used by `vb` is the directory name, so the example
above gives you two switchable boxes: `vb_box1` and `vb_box2`.

Box names must be unique. Paths that contain literal colons are not supported.

## Usage
The `vb` command comes with a few unique arguments.

|Argument|What it does|
|:------|:------------|
|`switch`|Switches to the next configured box.|
|`list`|Displays all available boxes, and which is currently being used.|
|`cd`|Changes your current directory to the current box location.|
|`echo`|Lists the full path to the current box.|
|`use [BOX]`|Sets the current box directly to `BOX`.|
|`-h`|Gives a brief usage.|

Use `vb switch` to cycle through the configured boxes, or `vb use vb_box1` to
switch directly by name. Tab-completion after `vb use` lists box names only, not
their full paths. Run `vb list` to see all configured boxes and the current
selection, or `vb echo` to print the selected box's full path.

With any other argument, `vb` attempts to forward to the `vagrant` command. Use
this feature to run common `vagrant` commands, such as `up`, `ssh`, `halt`,
etc., from anywhere.

## Customization
You can enable/disable colored terminal output, and even change
the colors, by adding the following to your shell init file.

```sh
VB_COLOR=false               # Default: true. Setting to false disables colors
# The following lines would make the colored output bold.
VB_SUCCESS_COLOR='\e[1;92m'  # Bold green.   Default: '\e[0;92m' (green)
VB_WARNING_COLOR='\e[1;93m'  # Bold yellow.  Default: '\e[0;93m' (yellow)
VB_ERROR_COLOR='\e[1;91m'    # Bold red.     Default: '\e[0;91m' (red)
```

By default, the cache file is `$ZSH_CACHE_DIR/vb.cache` when `ZSH_CACHE_DIR` is
set, or `~/.cache/vb/vb.cache` otherwise. To change this, set `VB_CACHE` to a
directory or file name in your shell init file. If `VB_CACHE` points to a
directory, either an existing directory or a string ending in `/`, the file name
will always be `vb.cache`. If the directory doesn't exist, it will be created
with `mkdir -p`.

```sh
VB_CACHE=$HOME/.vb.cache
```

## Reporting bugs
If you have an idea or find a bug, please [create an
issue](https://github.com/evanthegrayt/vagrant-box-wrapper/issues/new). Just
make sure the topic
doesn't already exist.

If you have an issue with tab-completion, make sure you have completion enabled
for your shell
([bash](https://www.gnu.org/software/bash/manual/html_node/Programmable-Completion.html)
/ [zsh](http://zsh.sourceforge.net/Doc/Release/Completion-System.html)). If,
after reading the manual, you still have problems, feel free to submit an issue.

## Self-Promotion
I do these projects for fun, and I enjoy knowing that they're helpful to people.
Consider starring [the
repository](https://github.com/evanthegrayt/vagrant-box-wrapper) if you like it!
If you love it, follow me [on github](https://github.com/evanthegrayt)!
