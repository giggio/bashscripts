# these are aliases that only exist if you are on WSL
if ! $WSL; then return; fi
alias explorer='explorer.exe'
alias cmd='cmd.exe'
alias powershell='powershell.exe'
alias start='pwsh.exe -NoProfile -NoLogo -c start'