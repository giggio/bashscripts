# shellcheck disable=SC2139
# these are aliases that only exist if you are on WSL
if ! $WSL; then return; fi
alias explorer='"'"`find_in_win_path explorer.exe`"'"'
alias cmd='"'"`find_in_win_path cmd.exe`"'"'
alias powershell='"'"`find_in_win_path powershell.exe`"'"'
alias start='"'"`find_in_win_path pwsh.exe`"'" -NoProfile -NoLogo -c start'
alias clip='"'"`find_in_win_path clip.exe`"'"'
alias notepad='"'"`find_in_win_path notepad.exe`"'"'
alias wt='"'"`find_in_win_path wt.exe`"'"'
alias ver='pushd /mnt/c > /dev/null;cmd /c ver; pushd > /dev/null'
alias gitk='"'"`find_in_win_path gitk.exe`"'"'
alias ipconfig='"'"`find_in_win_path ipconfig.exe`"'"'
alias gpg-connect-agent='"'"`find_in_win_path gpg-connect-agent.exe`"'"'
