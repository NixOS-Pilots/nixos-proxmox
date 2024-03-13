# justfile
# cheatsheet: https://cheatography.com/linux-china/cheat-sheets/justfile/

# define alias

# set options
set positional-arguments := true

# default recipe to display help information
default:
  @just --list

# build pkg
build pkg:
  @nom build .#{{ pkg }}

# check version
version pkg:
  @./result/bin/{{ pkg }} --version

# update all flake inputs
update:
  @nix flake update

# show flake
show:
  @nix flake show

# check flake
check:
  @nix flake check

# apply fix from linters
lint:
  @statix fix --ignore 'templates/' .
  @deadnix --edit --exclude 'templates/' .

# update a particular flake input
update-input input:
  @nix flake lock --update-input {{ input }}

# nix-prefetch-url
prefetch-url url:
  @nix-prefetch-url --type sha256 '{{ url }}' | xargs nix hash to-sri --type sha256

# nix-prefetch-git
prefetch-git repo rev:
  @nix-prefetch-git --url 'git@github.com:{{ repo }}' --rev '{{ rev }}' --fetch-submodules

# stage all files
add:
  @git add .
