# set a fancy prompt (non-color, overwrite the one in /etc/profile)
export PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

# shortcuts
alias la='ls $LS_OPTIONS -all -h'
