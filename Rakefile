require 'rake'
require 'fileutils'

desc "Hook Unix configs into system-standard positions."
task :install => [:submodule_init, :submodules] do
  puts
  puts "======================================================"
  puts "Welcome to Unix configs Installation."
  puts "======================================================"
  puts

  install_homebrew if RUBY_PLATFORM.downcase.include?("darwin") && want_to_install?('brew')
  install_rbenv if want_to_install?('rbenv')
  install_gems if want_to_install?('gems')

  # this has all the runcoms from this directory.
  install_files(Dir.glob('git/*')) if want_to_install?('git configs (color, aliases)')
  install_files(Dir.glob('tmux/*')) if want_to_install?('tmux config')
  install_files(files = Dir.glob('bash/runcoms/*'), method = :symlink,
    withDirectories = false) if want_to_install?('bash configs')

  link_binaries('shells/bins') if want_to_install?('custom binaries')

  Rake::Task["install_prezto"].execute if want_to_install?('prezto')

  install_files(Dir.glob('zsh/overrides/*')) if want_to_install?('override default configs')

  install_fonts if want_to_install?('powerline fonts')

  install_term_theme if RUBY_PLATFORM.downcase.include?("darwin") && want_to_install?('solarized theme')

  copy_files('keyboard/layouts', '/Library/Keyboard\ Layouts', 'sudo') if
    RUBY_PLATFORM.downcase.include?("darwin") && want_to_install?('external UK keyboard layouts')

  run_bundle_config if want_to_install?('bundle config')

  success_msg("installed")
end

task :install_prezto do
  if want_to_install?('zsh enhancements & prezto')
    install_prezto
  end
end

task :submodule_init do
  unless ENV["SKIP_SUBMODULES"]
    run %{ git submodule update --init --recursive }
  end
end

desc "Init and update submodules."
task :submodules do
  unless ENV["SKIP_SUBMODULES"]
    puts "======================================================"
    puts "Downloading Unix configs submodules...please wait"
    puts "======================================================"

    run %{
      cd $DOTFILES_DIR
      git submodule update --recursive
      git clean -df
    }
    puts
  end
end

task :default => 'install'

private
def run(cmd)
  puts "[Running] #{cmd}"
  `#{cmd}` unless ENV['DEBUG']
end

def number_of_cores
  if RUBY_PLATFORM.downcase.include?("darwin")
    cores = run %{ sysctl -n hw.ncpu }
  else
    cores = run %{ nproc }
  end
  puts
  cores.to_i
end

def run_bundle_config
  return unless system("which bundle")

  bundler_jobs = number_of_cores - 1
  puts "======================================================"
  puts "Configuring Bundlers for parallel gem installation"
  puts "======================================================"
  run %{ bundle config --global jobs #{bundler_jobs} }
  puts
end

def install_homebrew
  run %{which brew}
  unless $?.success?
    puts "======================================================"
    puts "Installing Homebrew, the OSX package manager...If it's"
    puts "already installed, this will do nothing."
    puts "======================================================"
    run %{ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"}
  end

  puts
  puts
  puts "======================================================"
  puts "Updating Homebrew."
  puts "======================================================"
  run %{brew update}
  puts
  puts
  puts "======================================================"
  puts "Installing Homebrew packages...There may be some warnings."
  puts "======================================================"
  run %{brew install ctags hub}
  run %{brew tap homebrew/bundle}
  run %{brew bundle}
  puts
  puts
end

def install_rbenv
  ruby_version = '2.2.2'

  run %{which rbenv}
  unless $?.success?
    puts "======================================================"
    puts "Installing rbenv"
    puts "already installed, this will do nothing."
    puts "======================================================"
    run %{brew install rbenv ruby-build}
  end

  puts
  puts
  puts "======================================================"
  puts "Updating rbenv."
  puts "======================================================"
  run %{brew upgrade rbenv ruby-build}
  run %{rbenv install -s #{ruby_version}}
  run %{rbenv global #{ruby_version}}
  puts
  puts
end

def install_gems
  run %{which gem}
  unless $?.success?
    puts "======================================================"
    puts "Install gem and try again."
    puts "======================================================"
    return
  end

  puts
  puts
  puts "======================================================"
  puts "Installing Gems...There may be some warnings."
  puts "======================================================"
  run %{gem install bundler git-up}
  puts
  puts
end

def install_fonts
  puts "======================================================"
  puts "Installing patched fonts for Powerline/Lightline."
  puts "======================================================"
  run %{ cp -f $DOTFILES_DIR/fonts/* $HOME/Library/Fonts } if RUBY_PLATFORM.downcase.include?("darwin")
  run %{ mkdir -p ~/.fonts && cp $DOTFILES_DIR/fonts/* ~/.fonts && fc-cache -vf ~/.fonts } if RUBY_PLATFORM.downcase.include?("linux")
  puts
end

def install_term_theme
  puts "======================================================"
  puts "Restoring iTerm2 settings."
  puts "======================================================"
  if File.exists?('iTerm2/com.googlecode.iterm2.plist')
    run %{cp -f iTerm2/com.googlecode.iterm2.plist ~/Library/Preferences/com.googlecode.iterm2.plist}
  end

  puts "======================================================"
  puts "Installing iTerm2 solarized theme."
  puts "======================================================"
  run %{ /usr/libexec/PlistBuddy -c "Add :'Custom Color Presets':'Solarized Light' dict" ~/Library/Preferences/com.googlecode.iterm2.plist }
  run %{ /usr/libexec/PlistBuddy -c "Merge 'iTerm2/themes/Solarized-Light.itermcolors' :'Custom Color Presets':'Solarized Light'" ~/Library/Preferences/com.googlecode.iterm2.plist }
  run %{ /usr/libexec/PlistBuddy -c "Add :'Custom Color Presets':'Solarized Dark' dict" ~/Library/Preferences/com.googlecode.iterm2.plist }
  run %{ /usr/libexec/PlistBuddy -c "Merge 'iTerm2/themes/Solarized-Dark.itermcolors' :'Custom Color Presets':'Solarized Dark'" ~/Library/Preferences/com.googlecode.iterm2.plist }

  # If iTerm2 is not installed or has never run, we can't autoinstall the profile since the plist is not there
  if !File.exists?(File.join(ENV['HOME'], '/Library/Preferences/com.googlecode.iterm2.plist'))
    puts "======================================================"
    puts "To make sure your profile is using the solarized theme"
    puts "Please check your settings under:"
    puts "Preferences> Profiles> [your profile]> Colors> Load Preset.."
    puts "======================================================"
    return
  end

  # Ask the user which theme he wants to install
  message = "Which theme would you like to apply to your iTerm2 profile?"
  color_scheme = ask message, iTerm_available_themes

  return if color_scheme == 'None'

  color_scheme_file = File.join('iTerm2/themes', "#{color_scheme}.itermcolors")

  # Ask the user on which profile he wants to install the theme
  profiles = iTerm_profile_list
  message = "I've found #{profiles.size} #{profiles.size>1 ? 'profiles': 'profile'} on your iTerm2 configuration, which one would you like to apply the Solarized theme to?"
  profiles << 'All'
  selected = ask message, profiles

  if selected == 'All'
    (profiles.size-1).times { |idx| apply_theme_to_iterm_profile_idx idx, color_scheme_file }
  else
    apply_theme_to_iterm_profile_idx profiles.index(selected), color_scheme_file
  end
end

def iTerm_available_themes
   Dir['iTerm2/themes/*.itermcolors'].map { |value| File.basename(value, '.itermcolors')} << 'None'
end

def iTerm_profile_list
  profiles=Array.new
  begin
    profiles <<  %x{ /usr/libexec/PlistBuddy -c "Print :'New Bookmarks':#{profiles.size}:Name" ~/Library/Preferences/com.googlecode.iterm2.plist 2>/dev/null}
  end while $?.exitstatus==0
  profiles.pop
  profiles
end

def ask(message, values)
  puts message
  while true
    values.each_with_index { |val, idx| puts " #{idx+1}. #{val}" }
    selection = STDIN.gets.chomp
    if (Float(selection)==nil rescue true) || selection.to_i < 0 || selection.to_i > values.size+1
      puts "ERROR: Invalid selection.\n\n"
    else
      break
    end
  end
  selection = selection.to_i-1
  values[selection]
end

def install_prezto
  puts
  puts "Installing Prezto (ZSH Enhancements)..."

  run %{ ln -nfs "$DOTFILES_DIR/zsh/prezto" "${ZDOTDIR:-$HOME}/.zprezto" }

  # The prezto runcoms are only going to be installed if zprezto has never been installed
  install_files(Dir.glob('zsh/prezto/runcoms/z*'), :symlink)

  if ENV["SHELL"].include? 'zsh' then
    puts "Zsh is already configured as your shell of choice. Restart your session to load the new settings"
  else
    puts "Setting zsh as your default shell"
    if File.exists?("/usr/local/bin/zsh")
      if File.readlines("/private/etc/shells").grep("/usr/local/bin/zsh").empty?
        puts "Adding zsh to standard shell list"
        run %{ echo "/usr/local/bin/zsh" | sudo tee -a /private/etc/shells }
      end
      run %{ chsh -s /usr/local/bin/zsh }
    else
      run %{ chsh -s /bin/zsh }
    end
  end
end

def want_to_install? (section)
  if ENV["ASK"]=="true"
    puts "Would you like to install configuration files for: #{section}? [y]es, [n]o"
    STDIN.gets.chomp == 'y'
  else
    true
  end
end

def copy_files (src, dest, prefix)
  puts "======================================================"
  puts "Copying files from #{src} to #{dest} ..."
  puts "======================================================"

  run %{mkdir -p #{dest}}

  if File.exists?(src) && File.exists?(dest)
    run %{#{prefix} cp -rfv #{src}/* #{dest}/}
  end
end

def install_files(files, method = :symlink, withDirectories = true)
  files.each do |f|
    file = f.split('/').last
    source = "#{ENV["PWD"]}/#{f}"
    target = "#{ENV["HOME"]}/.#{file}"

    puts "======================#{file}=============================="
    puts "Source: #{source}"
    puts "Target: #{target}"

    if File.exists?(target) && (!File.symlink?(target) || (File.symlink?(target) && File.readlink(target) != source))
      puts "[Overwriting] #{target}...leaving original at #{target}.backup..."
      run %{ mv "$HOME/.#{file}" "$HOME/.#{file}.backup" }
    end

    if !File.directory?(source) || withDirectories
      if method == :symlink
        run %{ ln -nfs "#{source}" "#{target}" }
      elsif
        run %{ cp -f "#{source}" "#{target}" }
      end
    end

    puts "=========================================================="
    puts
  end
end

def link_binaries(path)
  # create home .bins dir if not exists
  home_bins = File.join(Dir.home, ".bins")
  Dir.mkdir(home_bins) unless Dir.exist?(home_bins)

  # list all the binaries recursivelly
  binaries = Dir.glob(path << '/*/*')
  binaries.each do |bin|
    orig_path = "#{ENV["DOTFILES_DIR"]}/#{bin}"
    bin_name = File.basename(bin.split('/').last, '.*')
    dest_path = File.join(home_bins, bin_name)

    puts
    puts "======================#{file}=============================="
    puts "Source: #{orig_path}"
    puts "Target: #{dest_path}"
    run %{ln -nfs #{orig_path} #{dest_path}}
    puts "=========================================================="
    puts
  end
end

def apply_theme_to_iterm_profile_idx(index, color_scheme_path)
  values = Array.new
  16.times { |i| values << "Ansi #{i} Color" }
  values << ['Background Color', 'Bold Color', 'Cursor Color', 'Cursor Text Color', 'Foreground Color', 'Selected Text Color', 'Selection Color']
  values.flatten.each { |entry| run %{ /usr/libexec/PlistBuddy -c "Delete :'New Bookmarks':#{index}:'#{entry}'" ~/Library/Preferences/com.googlecode.iterm2.plist } }

  run %{ /usr/libexec/PlistBuddy -c "Merge '#{color_scheme_path}' :'New Bookmarks':#{index}" ~/Library/Preferences/com.googlecode.iterm2.plist }
  run %{ defaults read com.googlecode.iterm2 }
end

def success_msg(action)
  puts "Unix configs have been #{action}. Please restart your terminal."
end