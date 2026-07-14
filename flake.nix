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
        { self', pkgs, ... }:

        {
          packages.action-docs = pkgs.callPackage "${inputs.infra}/pkgs/action-docs/package.nix" { };

          treefmt = {
            programs.actionlint.enable = true;
            settings.formatter.actionlint.options = [
              "-config-file"
              ".forgejo/actionlint.yaml"
            ];
            programs.nixfmt.enable = true;
            programs.deadnix.enable = true;
            programs.yamlfmt.enable = true;
            settings.formatter.action-docs = {
              command = pkgs.writeShellApplication {
                name = "run-action-docs";
                runtimeInputs = [
                  self'.packages.action-docs
                  pkgs.markdownlint-cli
                ];
                text = ''
                  set -e
                  for file in "$@"; do
                    action="$(dirname "$file")/action.yml"  
                    if [ ! -f "$action" ]; then
                      continue
                    fi

                    # HACK: because action-docs writes to the file anyway
                    orig_time=$(stat -c "@%Y" "$file")
                    pre_hash=$(sha256sum "$file" | cut -d' ' -f1)

                    pushd "$(dirname "$file")"
                    action-docs -u -s "$action"
                    popd

                    sed -i -e 's|<p>||g' -e 's|</p>||g' "$file"
                    markdownlint -f "$file" || true # leniently accept defeat if action-docs made a mess
                    post_hash=$(sha256sum "$file" | cut -d' ' -f1)
                    if [ "$pre_hash" = "$post_hash" ]; then
                      touch -d "$orig_time" "$file"
                    fi
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
              self'.packages.action-docs
            ];
          };
        };
    };
}
