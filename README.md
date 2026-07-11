# setup-home

Small useful action for when you need to sign commits in CI, or need to access
or push to private repos.

<!-- action-docs-header source="action.yml" -->

<!-- action-docs-header source="action.yml" -->

<!-- action-docs-inputs source="action.yml" -->
## Inputs

| name | description | required | default |
| --- | --- | --- | --- |
| `ssh-private-key` | SSH private key | `false` | `""` |
| `ssh-known-hosts` | SSH known hosts | `false` | `""` |
| `gpg-privkey` | GPG private key | `false` | `""` |
| `gpg-key-id` | GPG key ID | `false` | `""` |
| `forge-hostname` | Forgejo hostname | `true` | `git.bartoostveen.nl` |
| `forge-username` | Forgejo username | `true` | `forgejo` |
| `git-user-name` | Git committer user name | `true` | `forgejo-actions[bot]` |
| `git-user-email` | Git committer user email | `true` | `git@bartoostveen.nl` |
<!-- action-docs-inputs source="action.yml" -->

<!-- action-docs-outputs source="action.yml" -->

<!-- action-docs-outputs source="action.yml" -->

<!-- action-docs-runs source="action.yml" -->
## Runs

This action is a `composite` action.
<!-- action-docs-runs source="action.yml" -->
