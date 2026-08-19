# Contributing

## Development setup

Run `bin/setup` once after cloning. It installs dependencies and points
`core.hooksPath` at `.githooks/`, enabling a `commit-msg` hook that enforces
Conventional Commits locally.

Run the linter and the tests the same way CI does:

```bash
bundle exec rubocop -c .rubocop.yml --parallel
bundle exec rspec -fp
```

## Commit messages — Conventional Commits

This project follows [Conventional Commits](https://www.conventionalcommits.org/).
The version bump and the `CHANGELOG.md` are generated automatically from commit
messages, so the prefix matters:

| Type | When to use | Release effect |
|------|-------------|----------------|
| `feat:` | New capability | minor bump |
| `fix:` | Bug fix | patch bump |
| `feat!:` or a `BREAKING CHANGE:` footer | Backwards-incompatible change | minor bump while `0.x`, major from `1.0` on |
| `chore:` `ci:` `docs:` `style:` `test:` `refactor:` | Maintenance | no release |

Pull requests are squash-merged, so **the PR title becomes the commit message**
release-please reads. Get the title right even when the individual commits are
messy.

> One thing to keep in mind when changing result types: the FService matchers
> compare the type list for **equality**, not inclusion. Adding a type to an
> existing result — say a second alias for a status — breaks every consuming spec
> that matches the exact list (`have_failed_with(:conflict, :client_error)`), even
> though `on_failure(:conflict)` hooks keep working. Treat it as a breaking change.

## Releasing (release-please)

Releases are automated with [release-please](https://github.com/googleapis/release-please);
there is no version to edit and no tag to create by hand.

1. Every push to `master` creates or updates a **release PR** titled
   `chore(master): release X.Y.Z`. It bumps `lib/f_http_client/version.rb`,
   `.release-please-manifest.json` and `Gemfile.lock`, and updates `CHANGELOG.md`
   from the Conventional Commits made since the last release.
2. **Do not edit `CHANGELOG.md` by hand.** release-please owns it.
3. **Merging the release PR** creates the git tag `vX.Y.Z` and a GitHub Release.
   That triggers `.github/workflows/publish.yml`, which publishes the gem to
   RubyGems through [Trusted Publishing](https://guides.rubygems.org/trusted-publishing/)
   — OIDC, with no API key stored in this repository. Consumers resolve it normally:

   ```ruby
   gem 'f_http_client', '~> 0.3'
   ```

4. The release PR always reflects **everything on `master` since the last
   release**. Cut releases promptly: merge the release PR before landing
   unrelated work you don't want included.

> Why this exists: 0.3.0 was published to RubyGems in February 2026, but the tag
> `v0.3.0` was never created — the newest tag is still `v0.2.1`, from 2023. So the
> released code has no reference point in git: no compare link, no way to check out
> what shipped. Nothing in the manual process caught that, and it had happened
> silently for a whole release.

## If the release PR is failing

release-please only rebuilds the release branch when a **releasable** commit
(`feat:` / `fix:`) lands on `master`. Non-releasable commits (`chore:`, `ci:`,
`docs:`, `style:`, `test:`) do **not** rebuild it, so the release branch can fall
behind `master` and its CI can run stale code.

When the release PR's CI is red:

1. Push the fix to `master` through a normal PR. **Never** push directly to the
   `release-please--…` branch — release-please overwrites it.
2. If those fix commits are non-releasable (so the release PR won't refresh on its
   own), **close the release PR and delete its branch**. On the next push to
   `master`, release-please recreates it from the current `master`.
3. Merge the freshly recreated release PR.

Never manually rebase or force-push the release-please branch.

## If the gem was not published

The tag and the GitHub Release already exist, so publishing is retryable: fix the
cause and use **Re-run jobs** on the failed `Publish gem` workflow run. An
authentication failure points at the trusted publisher registration on RubyGems
(the repository and the workflow filename must match `publish.yml`), not at the
workflow itself.
