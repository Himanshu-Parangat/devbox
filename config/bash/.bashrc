#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return


bash_completion_file="/usr/share/bash-completion/bash_completion"

if [[ -r "$bash_completion_file" ]]; then
    source "$bash_completion_file"
else
    echo "Bash completion is missing or not readable: $bash_completion_file"
fi


HISTSIZE=100000
HISTFILESIZE=200000


alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

export PATH="$HOME/.local/bin:$PATH"

export STARSHIP_CONFIG=~/.config/starship.toml
eval "$(starship init bash)"
