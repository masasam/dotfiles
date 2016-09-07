# Path to Oh My Fish install.
set -q XDG_DATA_HOME
  and set -gx OMF_PATH "$XDG_DATA_HOME/omf"
  or set -gx OMF_PATH "$HOME/.local/share/omf"

# Load Oh My Fish configuration.
source $OMF_PATH/init.fish


function peco_select_history
  if set -q $argv
    history | peco | read line; commandline $line
  else
    history | peco --query $argv | read line; commandline $line
  end
  set -e line
end

#peco
function fish_user_key_bindings
    bind \cr peco_select_history
end


function peco_select_repository
  if set -q $argv
    ghq list -p | peco | read line; builtin cd $line
  else
    ghq list -p | peco --query $argv | read line; builtin cd $line
  end
  set -e line
end

#peco
function fish_user_key_bindings
    bind \c] peco_select_repository
end
