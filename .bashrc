# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific aliases and functions

#set -o vi

if [ -f `which powerline-daemon` ]; then
  powerline-daemon -q
  POWERLINE_BASH_CONTINUATION=1
  POWERLINE_BASH_SELECT=1
  . /usr/share/powerline/bash/powerline.sh
fi

#source /usr/share/git-core/contrib/completion/git-prompt.sh
#export PS1='[\u@\h \W$(__git_ps1 "(%s)")]\$ '
#export export PS1='[\u@\h \[\033[0;32m\]\W$(__git_ps1 "\[\033[0m\]\[\033[0;31m\](%s)\[\033[0m\]")]\$ '

export EDITOR=vim

export PIP_DOWNLOAD_CACHE=~/.cache/pip

# Have make print dirs in Asterisk so vim is happy
export PRINT_DIR=1

if [ -f ~/.agent.env ] ; then
    . ~/.agent.env > /dev/null
    if ! kill -0 $SSH_AGENT_PID > /dev/null 2>&1; then
        echo "Stale agent file found. Spawning new agent… "
        eval `ssh-agent | tee ~/.agent.env`
        ssh-add
    fi 
else
    echo "Starting ssh-agent"
    eval `ssh-agent | tee ~/.agent.env`
    ssh-add
fi

alias fssh='ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no'

alias matrix='LC_ALL=C tr -c "[:xdigit:]" " " < /dev/urandom | pv --rate-limit 10k | dd cbs=$COLUMNS conv=unblock | GREP_COLOR="1;32" grep --color "[^ ]"'

alias mk="make -j$[$(nproc) + 1]"
