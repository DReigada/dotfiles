#!/usr/bin/env fish

#
# Shell Settings
#

# Force my HOME (sudo compatibility)
export_globally DEFAULT_USER rtfpessoa

# Want your terminal to support 256 color schemes? I do ...
export_globally TERM xterm-256color
export_globally CLICOLOR 1
export_globally OPERATING_SYSTEM (uname)

# Languages
export_globally LANG en_GB.UTF-8
export_globally LC_COLLATE en_GB.UTF-8
export_globally LC_CTYPE en_GB.UTF-8
export_globally LC_MESSAGES en_GB.UTF-8
export_globally LC_MONETARY en_GB.UTF-8
export_globally LC_NUMERIC en_GB.UTF-8
export_globally LC_TIME en_GB.UTF-8
export_globally LC_ALL en_GB.UTF-8

# Editor
export_globally EDITOR vim
export_globally VISUAL vim
export_globally GREP_COLOR '1;33'

# Home
switch "$OPERATING_SYSTEM"
	case Linux
		# Linux
		export_globally HOME "/home/$DEFAULT_USER"
	case Darwin
		# Mac OSX
		export_globally HOME "/Users/$DEFAULT_USER"
end

# Visual Studio Code
switch "$OPERATING_SYSTEM"
	case Darwin
		function code
			begin
				set VSCODE_PATH "/Applications/Visual\ Studio\ Code.app/Contents"
				set ELECTRON "$VSCODE_PATH/MacOS/Electron"
				set CLI "$VSCODE_PATH/Resources/app/out/cli.js"
				set -lx ELECTRON_RUN_AS_NODE 1
				eval "$ELECTRON" "$CLI" "$argv"
			end
		end

	case Linux
		function code
			begin
				set VSCODE_PATH "/usr/share/code"
				set ELECTRON "$VSCODE_PATH/code"
				set CLI "$VSCODE_PATH/resources/app/out/cli.js"
				set -lx ELECTRON_RUN_AS_NODE 1
				eval "$ELECTRON" "$CLI" "$argv"
			end
		end
end

# GO
if test "$OPERATING_SYSTEM" = "Darwin"
	export_globally GOROOT "/usr/local/opt/go/libexec"
end
export_globally GOPATH "$HOME/.go"
add_to_path "$GOPATH/bin"

if test "$OPERATING_SYSTEM" = "Darwin"
	# coreutils
	add_to_path "/usr/local/opt/coreutils/libexec/gnubin"
	export_globally MANPATH "/usr/local/opt/coreutils/libexec/gnuman" $MANPATH
end

add_to_path "/usr/local/sbin"
add_to_path "/usr/local/bin"

# Node
if test -s "$HOME/.nodenv"
	add_to_path "$HOME/.nodenv/bin"
	add_to_path "$HOME/.nodenv/shims"
	source (eval $HOME/.nodenv/bin/nodenv init - --no-rehash fish | psub)
end

if which yarn 2>&1 >/dev/null
	add_to_path "$HOME/.config/yarn/global/node_modules/.bin"
end

# Ruby
if test -s "$HOME/.rbenv"
	add_to_path "$HOME/.rbenv/bin"
	add_to_path "$HOME/.rbenv/shims"
	source (eval $HOME/.rbenv/bin/rbenv init - --no-rehash fish | psub)
end

# Python
add_to_path "/usr/local/opt/python@2/bin"
if test -s "$HOME/.pyenv/bin/pyenv"
	export_globally PYENV_ROOT "$HOME/.pyenv"
	add_to_path "$PYENV_ROOT/bin"
	source (eval $HOME/.pyenv/bin/pyenv init - --no-rehash fish | psub)
end

# Java
if test -s "$HOME/.jabba/jabba.fish"
	source "$HOME/.jabba/jabba.fish"
end

# krypt.co
export_globally GPG_TTY (tty)

# Rust
add_to_path "$HOME/.cargo/bin"
