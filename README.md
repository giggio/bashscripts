My bash files
------

These are the files that accompany my
[Bash-it](https://github.com/Bash-it/bash-it)
installation.

This repo will work better with
[my dotfiles](https://github.com/giggio/dotfiles).

Installation
------

* Install Bash-it
* Clone this repo to ~/bashscripts:
````bash
  git clone --recurse-submodules https://github.com/giggio/bashscripts
````
* Add these 3 lines to the end of your `~/.bashrc` or `~/.bash_profile` (the
  `.bash_it.sh` should already be there):
````bash
# Load Bash It
export BASH_IT_CUSTOM="$HOME/bashscripts/"
source "$BASH_IT"/bash_it.sh
````

Author
------

[Giovanni Bassi](https://github.com/giggio)

License
-------

Licensed under the Apache License, Version 2.0.
