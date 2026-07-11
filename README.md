# setup-home

Small useful action for when you need to sign commits in CI, or need to access
or push to private repos.

This creates a temporary home directory and puts its path in the `HOME`
environment variable. It optionally contains a `.ssh/config`, and an OpenPGP
keybox populated with a GPG private key. It also configures git with some
sensible defaults for CI, and GPG signing setup if `${{ inputs.gpg-privkey}}`
is not empty. This makes it possible to just `git commit && git push` in CI
later, without having to worry about making tooling that make use of Git do the
correct thing.

This also does a few connection tests, so your pipeline fails early if SSH is broken.

<!-- action-docs-header source="action.yml" -->

<!-- action-docs-header source="action.yml" -->

<!-- action-docs-inputs source="action.yml" -->
## Inputs

| name | description | required | default |
| --- | --- | --- | --- |
| `ssh-private-key` | SSH private key to use, gets stored in $HOME/.ssh/id_ed25519 | `false` | `""` |
| `ssh-known-hosts` | SSH known hosts file, useful for locking the Git forge's public keys | `false` | `""` |
| `gpg-privkey` | GPG private key to import in the OpenPGP keyboy | `false` | `""` |
| `gpg-key-id` | GPG key ID of the PGP key in <code>gpg-privkey</code> | `false` | `""` |
| `forge-hostname` | Hostname of the Git forge this action runs on, gets populated in the SSH config | `true` | `git.bartoostveen.nl` |
| `forge-username` | Username of the Git forge this action runs on | `true` | `forgejo` |
| `git-user-name` | Git committer username, gets used when running <code>git commit</code> | `true` | `forgejo-actions[bot]` |
| `git-user-email` | Git committer email, gets used when running <code>git commit</code> | `true` | `git@bartoostveen.nl` |
| `verbose` | Whether to be verbose (log debug SSH config / connection tests) | `true` | `false` |
<!-- action-docs-inputs source="action.yml" -->

<!-- action-docs-outputs source="action.yml" -->

<!-- action-docs-outputs source="action.yml" -->

<!-- action-docs-runs source="action.yml" -->
## Runs

This action is a `composite` action.
<!-- action-docs-runs source="action.yml" -->
