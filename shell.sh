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

# some ls aliases
alias ll='ls -GlF'
alias la='ls -A'
alias l='ls -CF'

# Always run 'rm' in interactive mode.
alias rm='rm -i'

# Start a web server
alias serve="python3 -m http.server 3000"

# Restart the shell.
restart-shell() {
  exec -l $SHELL
}

# Make a directory (don't fail if it exists) and move into it in one line.
function mkd {
  mkdir -p -- "$1" && cd -P -- "$1";
}
