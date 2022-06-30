# My bash files

These are my bash files. It uses
[starship](https://starship.rs/)
to customize the prompt, so you need it in PATH.

This repo will work better with
[my dotfiles](https://github.com/giggio/dotfiles).

## Installation

* Clone this repo to ~/bashscripts:
````bash
  git clone --recurse-submodules https://github.com/giggio/bashscripts
````
* Add this line to the end of your `~/.bashrc` or `~/.bash_profile`:
````bash
source $HOME/bashscripts/.bashrc
````

## Extending these scripts

It will run every file with `.bash` at the end, so all you need to do is add
more files. Files are sorted and directories closer to the root of the repo will
run first.

## Author
[Giovanni Bassi](https://github.com/giggio)

## License
Licensed under the Apache License, Version 2.0.
