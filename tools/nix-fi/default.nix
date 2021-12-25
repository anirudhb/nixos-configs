{ writeShellApplication, jq, ... }: writeShellApplication {
  name = "nix-fi";
  runtimeInputs = [ jq ];
  text = ''
    set -e
    set +u
    [[ -n "$FLAKERUS_DEBUG" ]] && set -x
    set -u
    case $1 in
      -*) need_help=1;;
    esac
    if [[ -n "$need_help" ]]; then
      echo "Usage: nix-fi [packages]"
      echo
      echo "Initializes a flake and direnv with the given packages"
      exit
    fi
    echo "==> Querying name of system..."
    system=$(nix eval --impure --raw --expr "builtins.currentSystem")
    echo "==> Initializing flake..."
    cp ${./flake-template.nix} flake.nix
    sed -i.bak "s/@@SYSTEM@@/$system/g" flake.nix
    rm -f flake.nix.bak || true
    buildinputs=$(IFS=" "; echo "$*")
    sed -i.bak "s/@@BUILDINPUTS@@/$buildinputs/g" flake.nix
    rm -f flake.nix.bak || true
    echo "==> Creating lock file from hm config..."
    locked_nixpkgs=$(jq -r '.nodes[.nodes[.root].inputs.nixpkgs].locked as $locked | "\($locked.type):\($locked.owner)/\($locked.repo)/\($locked.rev)"' < ~/nixos-configs/flake.lock)
    nix flake lock --override-input nixpkgs "$locked_nixpkgs"
    echo "==> Creating envrc..."
    echo "use flake" > .envrc
    echo "==> Allowing envrc..."
    direnv allow
    echo "==> Done!"
  '';
}
