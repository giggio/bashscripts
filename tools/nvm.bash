export NVM_DIR="$HOME/.nvm"
# lazy load nvm, which is slow to start, so we dont 'use' at first, and alias node and npm to 'use'
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" --no-use # This loads nvm without use
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
nvm_use () { nvm use --silent default; }
alias node='unalias node; unalias npm; unalias nvm; nvm_use; node $@'
alias npm='unalias node; unalias npm; unalias nvm; nvm_use; npm $@'
alias nvm='unalias node; unalias npm; unalias nvm; nvm_use; nvm $@'
