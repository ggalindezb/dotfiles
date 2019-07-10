# ~/.bashrc
# WARNING: Here be dragons

# ------------------------------------------------
# Color bindings
# ------------------------------------------------
txtblk='\e[0;30m' # Black - Regular
txtred='\e[0;31m' # Red
txtgrn='\e[0;32m' # Green
txtylw='\e[0;33m' # Yellow
txtblu='\e[0;34m' # Blue
txtpur='\e[0;35m' # Purple
txtcyn='\e[0;36m' # Cyan
txtwht='\e[0;37m' # White
bldblk='\e[1;30m' # Black - Bold
bldred='\e[1;31m' # Red
bldgrn='\e[1;32m' # Green
bldylw='\e[1;33m' # Yellow
bldblu='\e[1;34m' # Blue
bldpur='\e[1;35m' # Purple
bldcyn='\e[1;36m' # Cyan
bldwht='\e[1;37m' # White
unkblk='\e[4;30m' # Black - Underline
undred='\e[4;31m' # Red
undgrn='\e[4;32m' # Green
undylw='\e[4;33m' # Yellow
undblu='\e[4;34m' # Blue
undpur='\e[4;35m' # Purple
undcyn='\e[4;36m' # Cyan
undwht='\e[4;37m' # White
bakblk='\e[40m'   # Black - Background
bakred='\e[41m'   # Red
bakgrn='\e[42m'   # Green
bakylw='\e[43m'   # Yellow
bakblu='\e[44m'   # Blue
bakpur='\e[45m'   # Purple
bakcyn='\e[46m'   # Cyan
bakwht='\e[47m'   # White
txtrst='\e[0m'    # Text Reset
# ------------------------------------------------

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# ------------------------------------------------
# Shell preferences
# ------------------------------------------------
alias ls='ls -lFGpHh'
alias tree='tree -C'
complete -cf sudo

# -- Init ---------------
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

# ------------------------------------------------
# Environment
# ------------------------------------------------
export LC_ALL=en_US.UTF-8

# ------------------------------------------------
# Prompt
# ------------------------------------------------

# Add git branch to the prompt
function git_branch {
    git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/{\1}/'
}

# Brackets
open="\[$bldgrn\]["       # Opening bracket
close="\[$bldgrn\]]"      # Closing bracket

# Prompt setup
git="\[$txtylw\]\$(git_branch)"
data="${open}\[$txtblu\]\u@\[$txtgrn\]\H \[$txtcyn\]\W${git}${close}"
ssh=""
end="\[$txtrst\] "

# SSH flag
if [ -n "$SSH_CLIENT" ]; then
    ssh="${open}\[$txtgrn\]SSH${close}"
fi

prompt=$ssh$data$end
export PS1=$prompt

# ------------------------------------------------
# Path
# ------------------------------------------------
PATH=$PATH:/usr/local/sbin
PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting

# ------------------------------------------------
# Fun =D
# ------------------------------------------------
# Cowsay
fortune | cowsay
