# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# Source any files in our ~/.shell.d folder.
if [ -x ~/.shell.d ]; then
    for shellfile in ~/.shell.d/*; do
        [ -r "$shellfile" ] && source "$shellfile"
    done
    unset shellfile
fi

set_ps1 "eternallogger" || true

# Set our editor. Some tools use 'VISUAL', some use 'EDITOR'.
export VISUAL=nvim
export EDITOR=nvim

# 1. Standard Homebrew setup (automatically handles /bin and /sbin)
eval "$(/opt/homebrew/bin/brew shellenv)"
# Homebrew and Local Paths (replaces fish_add_path)
export PATH="/users/zhaoyuan/.local/bin:$PATH"

# Environment Variables
export LC_ALL=en_US.utf-8
export fzf_default_command='rg --files'
export fzf_ctrl_t_command="command find -L \$dir -type f 2> /dev/null | sed '1d; s#^\./##'"
export N8N_RESTRICT_FILE_ACCESS_TO="/Users/zhaoyuan/Git/AIAgentsN8N"

# Allow us to use Ctrl+S to perform forward search, by disabling the start and
# stop output control signals, which are not needed on modern systems.
stty -ixon
#
# Set a shell option but don't fail if it doesn't exist!
safe_set() { shopt -s "$1" >/dev/null 2>&1 || true; }

# Set some options to make working with folders a little easier. Note that we
# send all output to '/dev/null' as startup files should not write to the
# terminal and older shells might not have these options.
safe_set autocd         # Enter a folder name to 'cd' to it.
safe_set cdspell        # Fix minor spelling issues with 'cd'.
safe_set dirspell       # Fix minor spelling issues for commands.
safe_set cdable_vars    # Allow 'cd varname' to switch directory.

# Uncomment the below if you want to be able to 'cd' into directories that are
# not just relative to the current location. For example, if the below was
# uncommented we could 'cd my_project' from anywhere if 'my_project' is in
# the 'repos' folder.
# CDPATH="~:~/Git"

# Configure the history to make it large and support multi-line commands.
safe_set histappend                  # Don't overwrite the history file, append.
safe_set cmdhist                     # Multi-line commands are one entry only.
PROMPT_COMMAND='history -a'          # Before we prompt, save the history.
HISTSIZE=10000                       # A large number of commands per session.
HISTFILESIZE=100000                  # A huge number of commands in the file.
HISTCONTROL="ignorespace:ignoredup" # Ignore starting with space or duplicates?
export HISTIGNORE="ls:history"     # Any commands we want to not record?
# HISTTIMEFORMAT='%F %T '            # Do we want a timestamp for commands?

# Source custom aliases
[ -f ~/.shell_aliases ] && source ~/.shell_aliases

# Restart the shell.
restart-shell() {
  exec -l $SHELL
}

# Make a directory (don't fail if it exists) and move into it in one line.
function mkd {
  mkdir -p -- "$1" && cd -P -- "$1";
}

# Initialize Fast Node Manager (fnm)
eval "$(fnm env --use-on-cd)"
