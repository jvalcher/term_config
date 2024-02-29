#!/bin/bash

# import private settings
source $HOME/.bash_private

# start tmux
if [ -z $TMUX ]; then
    tmux
fi

# source .bashrc
alias s='source $HOME/.bashrc'

# exit (e)
alias e='exit'

# clear screen (c)
alias c='clear'

# enable bash-autompletion
source /etc/profile.d/bash_completion.sh

# vim
MY_VIM="/usr/bin/vim"

## tmux rename window
alias tw="tmux rename-window"

# rerun last command (r)
alias r='fc -s'

# add to PATH
export PATH=$HOME/bin:$HOME/.local/bin:$PATH
export LD_LIBRARY_PATH=$HOME/Git/library/c/lib:$LD_LIBRARY_PATH
export C_INCLUDE_PATH=$HOME/Git/library/c/inc:$C_INCLUDE_PATH

# prune duplicate paths
PATHS=("PATH" "LD_LIBRARY_PATH" "C_INCLUDE_PATH")
for P in "${PATHS[@]}"; do
    source $HOME/bin/prune_paths $P
done

# add syntax highlighting to less output
export LESSOPEN="| /usr/share/source-highlight/src-hilite-lesspipe.sh %s"
export LESS='-R'

# misc history settings
export HISTFILE=~/.history
export HISTFILESIZE=
export HISTSIZES=

# append to history on every command, don't empty on exit
export PROMPT_COMMAND="history -a;$PROMPT_COMMAND"
shopt -s histappend

# read man pages with vim
export MANPAGER='/bin/bash -c "vim -MRn -c \"set buftype=nofile showtabline=0 ft=man ts=8 nomod nolist norelativenumber nonu noma\" -c \"normal L\" -c \"nmap q :qa<CR>\"</dev/tty <(col -b)"'

# print pwd including file  (pwn file.txt  ->  /home/user/file.txt)
alias pwn="readlink -f"

# set trash-cli commands
alias rm="trash-put"
alias trash-list="trash-list | sort -k1,2"
alias trash-size="du -hs ~/.local/share/Trash/"

# python3 aliases
alias py="python3 "
alias python="python3"

# activate cursor selection for windows to get PID
alias winSel="xprop _NET_WM_PID | sed 's/_NET_WM_PID(CARDINAL) = //' | ps 'cat'"

# run vim goyo (vimg)
alias vimg="vim +Goyo"

# open haxor-news link in browser
alias hnb="hn view -b "

# grep -rnw search (gr)
alias gr="grep -rnw"

# valgrind (vg)
alias vg="valgrind --leak-check=full --track-origins=yes --show-reachable=yes"

# run feh borderless
alias feh="feh -x"

# add autocomplete for markdown files when using google-chrome
complete -f -X '!*.md' google-chrome

# turn highlight pasted text off
bind 'set enable-bracketed-paste off'

# return actual instead of soft link address with pwd
alias pwd="pwd -P"

# WSL
if grep -qi microsoft /proc/version; then

    # enable curl in WSL2
    alias curl="cmd.exe /C curl"

    # WSL Chrome 
    alias chrome="/c/Program\ Files\ \(x86\)/Google/Chrome/Application/chrome.exe"
fi

# disable terminal freeze with Ctrl+s
stty -ixon

# print formatted 'git log --graph' (gitg)
alias gitg="printf '\n'; git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)' --all; printf '\n'"

# formatted ll
llr () {
    # if no files in directory, return prompt
    if [ -z "$(ls $1)" ]; then
        printf ""
    # otherwise
    else
        # no dir argument
        if [ $# -eq 0 ]; then
            #printf "$(ls -1 -p --color=always | sed 's/^/    /')"
            printf "$(ls -1 -p --color=always)\n"
        # with dir argument
        else
            #printf "$(ls -1 -p --color=always $1 | sed 's/^/    /')"
            printf "$(ls -1 -p --color=always $1)\n"
        fi
    fi
}
alias ll="LC_COLLATE=C llr"

# formatted la, list just hidden files
lla () {
    # Exit codes with/without argument are 0 if 
    # no hidden files present
    STATE=$(ls -1d .!(|.) |& grep -q "No such file"; echo $?)
    STATE_ARGS=$(cd $1; ls -1d .!(|.) |& grep -q "No such file"; echo $?)
    # If no argument
    if [ $# -eq 0 ]; then
        if [ $STATE -eq 0 ]; then
            printf ""
        else
            printf "$(ls -1dp --color=always .!(|.))\n"
        fi
    # If argument
    else
        if [ $STATE_ARGS -eq 0 ]; then
            printf ""
        else
            printf "$(cd $1; ls -1dp --color=always .!(|.))\n"
        fi
    fi
}
alias la="lla"

# print directory contents after using `cd`
cd() {
    builtin cd "$@" && ll
}

# remove gdb message
alias gdb="gdb -q"

# open gdb in tui mode
alias gdt="gdb -tui"

# create "tty <current terminal tty>" string for gdb
alias ttg="echo 'tty $(tty)' | tee >(xclip -selection clipboard)"



############
# set prompt
############

# colors
DEFAULT="\[\033[0m\]"
    #
BLUE="\[\033[1;34m\]"
CYAN="\[\033[1;36m\]"
GOLD="\[\033[1;33m\]"
GRAY="\[\033[1;90m\]"
GREEN="\[\033[1;32m\]"
LIGHT_GREEN="\[\033[1;92m\]"
LIGHT_BLUE="\[\033[1;94m\]"
PURPLE="\[\033[1;95m\]"
TURQUOISE="\[\033[96m\]"
YELLOW="\[\033[1;93m\]"

set_prompt_vars() {
    PROMPT_MISC_CHARS=" ╭────[]"
    PROMPT_MISC_CHARS_LEN=${#PROMPT_MISC_CHARS}
    GIT_MISC_CHARS="───()"
    GIT_BRANCH=$(git rev-parse --abbrev-ref HEAD 2> /dev/null)
    if [ ${#GIT_BRANCH} -eq 0 ];then
        GIT_MISC_CHARS_LEN=0
        GIT_BRANCH_LEN=0
    else
        GIT_MISC_CHARS_LEN=${#GIT_MISC_CHARS}
        GIT_BRANCH_LEN=${#GIT_BRANCH}
    fi
    MISC_CHARS_LEN=$(($PROMPT_MISC_CHARS_LEN + $GIT_MISC_CHARS_LEN))
    PANE_WIDTH=$(tput cols)
    USR_HOST="$GREEN${USER}$DEFAULT@$CYAN${HOSTNAME}$DEFAULT"
    USR_HOST_LEN=$((${#USER} + 1 + ${#HOSTNAME}))
    MAX_CURR_DIR_LEN=$(($PANE_WIDTH - $USR_HOST_LEN - $GIT_BRANCH_LEN - $MISC_CHARS_LEN))
    CURR_DIR="$LIGHT_BLUE\$(truncate_curr_dir | sed 's/\//\[$DEFAULT\/$LIGHT_BLUE\]/g')$DEFAULT"
    PROMPT_SYMBOL="$YELLOW\$$DEFAULT"
}

truncate_curr_dir() {
    local DIR=$(pwd)
    local MAXLEN=$MAX_CURR_DIR_LEN
    if [ ${#DIR} -gt $MAXLEN ]; then
        echo "...${DIR: -($MAXLEN-3)}"
    else
        echo "$DIR"
    fi
}

print_git_branch() {
    if git rev-parse --git-dir > /dev/null 2>&1; then
        printf "\033[2D───(\033[1;93m$GIT_BRANCH\033[0m)"
    fi
}

set_prompt_vars

export PS1="\
   ╭─$CURR_DIR───[$USR_HOST]  \$(print_git_branch)\n\
   ╰─$PROMPT_SYMBOL "

# refresh prompt values if PANE_WIDTH or GIT_BRANCH has changed
pre_prompt () {
    CURR_PANE_WIDTH=$(tput cols)
    CURRENT_GIT_BRANCH=$(git rev-parse --abbrev-ref HEAD 2> /dev/null)
    if [[ "$PANE_WIDTH" != "$CURR_PANE_WIDTH"    || \
          "$GIT_BRANCH" != "$CURRENT_GIT_BRANCH" ]]
    then
        set_prompt_vars
    fi
}
PROMPT_COMMAND=pre_prompt

# End prompt set
################



#####################
# Set terminal colors
#####################
#
# List attributes
# ---------------
# $ dircolors -p
#
# Format
# ------
#  'no=01;37'
#  <attribute> = <effect> ; <fg_color> ; <bg_color>
# 
# Attributes
# ----------
# no    Global default
# so    Socket
# di    Directory
# do    Door
# bd    Block device
# cd    Character device
# or    Symbolic link pointing to a non-existent file
# mi    Non-existent file pointed to by a symbolic link (ls -l)
# su    File that is setuid (u+s)
# sg    File that is setgid (g+s)
# ca    File with capability
# tw    Directory that is sticky and other-writable (+t,o+w)
# ow    Directory that is other-writable (o+w) and not sticky
# st    Directory with the sticky bit set (+t) and not other-writable
# ex    Executable file (i.e. has 'x' set in permissions)
# ln    Symbolic link
# pi    Named pipe
#
# Effects
# -------
# 00	Default colour
# 01	Bold
# 04	Underlined
# 05	Flashing text
# 07	Reversed
# 08	Concealed
# 
# Foreground colors
# -----------------
# 30    Black
# 31    Red
# 32    Green
# 33    Orange
# 34    Blue
# 35    Purple
# 36    Cyan
# 37    Grey
# 90    Dark grey
# 91    Light red
# 92    Light green
# 93    Yellow
# 94    Light blue
# 95    Light purple
# 96    Turquoise
# 97    White
# 
# Background colors
# -----------------
# 40	Black 
# 41	Red 
# 42	Green 
# 43	Orange 
# 44	Blue 
# 45	Purple 
# 46	Cyan 
# 47	Grey 
# 100	Dark grey 
# 101	Light red 
# 102	Light green 
# 103	Yellow 
# 104	Light blue 
# 105	Light purple 
# 106	Turquoise 
# 107	White 
#
ls_color_defs=(
    'no=01;37'      
    'so=01;35'      
    'di=01;33'      
    'do=01;35'      
    'bd=40;33;01'   
    'cd=40;33;01'   
    'or=40;31;01'   
    'mi=37;41'         
    'su=37;41'      
    'sg=30;43'      
    'ca=30;41'      
    'tw=30;42'      
    'ow=34;42'      
    'st=37;44'      
    'ex=01;92'      
    'ln=01;45'      
    'pi=01;45'      
    '*.7z=01;31'    
    '*.aac=00;36'
    '*.ace=01;31'
    '*.alz=01;31'
    '*.arc=01;31'
    '*.arj=01;31'
    '*.asf=01;35'
    '*.au=00;36'
    '*.avi=01;35'
    '*.bmp=01;35'
    '*.bz2=01;31'
    '*.bz=01;31'
    '*.cab=01;31'
    '*.cgm=01;35'
    '*.cpio=01;31'
    '*.deb=01;31'
    '*.dl=01;35'
    '*.dwm=01;31'
    '*.dz=01;31'
    '*.ear=01;31'
    '*.emf=01;35'
    '*.esd=01;31'
    '*.flac=00;36'
    '*.flc=01;35'
    '*.fli=01;35'
    '*.flv=01;35'
    '*.gif=01;35'
    '*.gl=01;35'
    '*.gz=01;31'
    '*.jar=01;31'
    '*.jpeg=01;35'
    '*.jpg=01;35'
    '*.lha=01;31'
    '*.lrz=01;31'
    '*.lz4=01;31'
    '*.lz=01;31'
    '*.lzh=01;31'
    '*.lzma=01;31'
    '*.lzo=01;31'
    '*.m2v=01;35'
    '*.m4a=00;36'
    '*.m4v=01;35'
    '*.mid=00;36'
    '*.midi=00;36'
    '*.mjpeg=01;35'
    '*.mjpg=01;35'
    '*.mka=00;36'
    '*.mkv=01;35'
    '*.mng=01;35'
    '*.mov=01;35'
    '*.mp3=00;36'
    '*.mp4=01;35'
    '*.mp4v=01;35'
    '*.mpc=00;36'
    '*.mpeg=01;35'
    '*.mpg=01;35'
    '*.nuv=01;35'
    '*.oga=00;36'
    '*.ogg=00;36'
    '*.ogm=01;35'
    '*.ogv=01;35'
    '*.ogx=01;35'
    '*.opus=00;36'
    '*.pbm=01;35'
    '*.pcx=01;35'
    '*.pgm=01;35'
    '*.png=01;35'
    '*.ppm=01;35'
    '*.qt=01;35'
    '*.ra=00;36'
    '*.rar=01;31'
    '*.rm=01;35'
    '*.rmvb=01;35'
    '*.rpm=01;31'
    '*.rz=01;31'
    '*.sar=01;31'
    '*.spx=00;36'
    '*.svg=01;35'
    '*.svgz=01;35'
    '*.swm=01;31'
    '*.t7z=01;31'
    '*.tar=01;31'
    '*.taz=01;31'
    '*.tbz2=01;31'
    '*.tbz=01;31'
    '*.tga=01;35'
    '*.tgz=01;31'
    '*.tif=01;35'
    '*.tiff=01;35'
    '*.tlz=01;31'
    '*.txz=01;31'
    '*.tz=01;31'
    '*.tzo=01;31'
    '*.tzst=01;31'
    '*.vob=01;35'
    '*.war=01;31'
    '*.wav=00;36'
    '*.webm=01;35'
    '*.webp=01;35'
    '*.wim=01;31'
    '*.wmv=01;35'
    '*.xbm=01;35'
    '*.xcf=01;35'
    '*.xpm=01;35'
    '*.xspf=00;36'
    '*.xwd=01;35'
    '*.xz=01;31'
    '*.yuv=01;35'
    '*.z=01;31'
    '*.zip=01;31'
    '*.zoo=01;31'
    '*.zst=01;31'
)
LS_COLORS=''
for def in "${ls_color_defs[@]}"; do
    LS_COLORS="$LS_COLORS:$def"
done
export LS_COLORS


# move prompt to top of screen
clear

