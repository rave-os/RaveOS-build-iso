#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

# >>> RaveOS terminal greeting >>>
if [[ -f /etc/profile.d/raveos-fastfetch.sh ]]; then
    source /etc/profile.d/raveos-fastfetch.sh
fi
# <<< RaveOS terminal greeting <<<
