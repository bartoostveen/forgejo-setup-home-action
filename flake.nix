{
  description = "Small useful action for when you need to sign commits in CI, or need to access or push to private repos.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    infra = {
      url = "git+https://git.bartoostveen.nl/bart/infra.git";
      flake = false; # we only want a single package, we should really migrate to a separate flake sometime
    };
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
      ];

      imports = [
        inputs.treefmt-nix.flakeModule
      ];

      perSystem =
        { pkgs, ... }:

        let
          action-docs = pkgs.callPackage "${inputs.infra}/pkgs/action-docs/package.nix" { };
        in
        {
          treefmt = {
            programs.actionlint.enable = true;
            programs.nixfmt.enable = true;
            programs.deadnix.enable = true;
            programs.yamlfmt.enable = true;
            settings.formatter.action-docs = {
              command = pkgs.writeShellApplication {
                name = "run-action-docs";
                runtimeInputs = [
                  action-docs
                  pkgs.markdownlint-cli
                ];
                text = ''
                  set -e
                  for file in "$@"; do
                    pushd "$(dirname "$file")"
                    action="$(dirname "$file")/action.yml"
                    if [ -f "$action" ]; then
                      action-docs -u -s "$action"
                    fi

                    sed -i -e 's|<p>||g' -e 's|</p>||g' "$file"
                    markdownlint -f "$file"
                    popd
                  done 
                '';
              };
              includes = [
                "**/README.md"
                "README.md"
              ];
            };
          };

          devShells.default = pkgs.mkShell {
            packages = [
              action-docs
            ];
          };
        };
    };
}
