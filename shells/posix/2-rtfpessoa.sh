#!/bin/sh

#
# OS X Shell Settings
#

# Force my HOME (sudo compatibility)
export_globally DEFAULT_USER "dreigada"

# Want your terminal to support 256 color schemes? I do ...
export_globally TERM "xterm-256color"
export_globally CLICOLOR 1
export_globally OPERATING_SYSTEM "$(uname)"

# Languages
export_globally LANG "en_GB.UTF-8"
export_globally LC_COLLATE "en_GB.UTF-8"
export_globally LC_CTYPE "en_GB.UTF-8"
export_globally LC_MESSAGES "en_GB.UTF-8"
export_globally LC_MONETARY "en_GB.UTF-8"
export_globally LC_NUMERIC "en_GB.UTF-8"
export_globally LC_TIME "en_GB.UTF-8"
export_globally LC_ALL "en_GB.UTF-8"

# Editor
export_globally EDITOR "vim"
export_globally VISUAL "vim"
export_globally GREP_COLOR '1;33'

# Check https://wiki.archlinux.org/index.php/HiDPI
export_globally QT_SCALE_FACTOR 2

if [[ "$OSTYPE" == "linux-gnu" ]]; then
  # Linux
  export_globally HOME "/home/$DEFAULT_USER"
elif [[ "$OSTYPE" == "darwin"* ]]; then
  # Mac OSX
  export_globally HOME "/Users/$DEFAULT_USER"
fi

# Visual Studio Code
# Since in Linux we are using snap we do not need any alias :)
if [[ "$OSTYPE" == "darwin"* ]]; then
  code() {
	local VSCODE_PATH "/Applications/Visual\ Studio\ Code.app/Contents"
	local ELECTRON "$VSCODE_PATH/MacOS/Electron"
	local CLI "$VSCODE_PATH/Resources/app/out/cli.js"
	ELECTRON_RUN_AS_NODE=1 "$ELECTRON" "$CLI" "$@"
  }
fi

add_to_path "$HOME/.local/bin"

add_to_path "/usr/local/sbin"
add_to_path "/usr/local/bin"

if [[ "$OSTYPE" == "darwin"* ]]; then
  add_to_path "/usr/local/opt/coreutils/libexec/gnubin"
  export_globally MANPATH "/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"
fi

# krypt.co
export_globally GPG_TTY $(tty)

# Rust
add_to_path "$HOME/.cargo/bin"

# asdf
eval $HOME/.asdf/asdf.sh
eval $HOME/.asdf/completions/asdf.bash
