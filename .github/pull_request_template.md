## What changed

<!-- What this PR does and why. Link the ClickUp card or an issue if there is one. -->

## Type of change

<!-- Keep only what applies. It must match the Conventional Commit type in the PR title. -->

- [ ] `feat` — new capability *(triggers a minor release)*
- [ ] `fix` — bug fix *(triggers a patch release)*
- [ ] `refactor` — behaviour-preserving change *(no release)*
- [ ] `chore` / `ci` / `docs` / `test` / `style` — maintenance *(no release)*
- [ ] breaking change — `!` in the title or a `BREAKING CHANGE:` footer

## Behaviour before and after

<!--
Only when this changes existing behaviour. Describe what it did before, what it does
now, and what could break for a consumer.

Changing the types a result carries counts as breaking, even when only adding one:
the FService matchers compare the type list for equality, so a consuming spec doing
`have_failed_with(:conflict, :client_error)` fails once a third type shows up.
`on_failure` hooks are unaffected — they match by inclusion.
-->

## Additional context

<!-- Sources, articles, screenshots — anything that helps the review. -->

## TO-DO

<!-- Anything deliberately left out, to be picked up later. -->

## Checklist

- [ ] The **PR title** is a valid Conventional Commit (`type: short description`).
      This PR is squash-merged, so the title is the commit release-please reads to
      decide the next version and to write the `CHANGELOG.md`.
- [ ] `bundle exec rubocop -c .rubocop.yml --parallel` and `bundle exec rspec` pass
      locally.
- [ ] New behaviour ships with specs.
- [ ] The `CHANGELOG.md` was **not** edited by hand and the version was **not**
      bumped; release-please owns both.
- [ ] A breaking change is flagged with `!` or a `BREAKING CHANGE:` footer, and says
      what consumers should use instead.

<!-- See CONTRIBUTING.md for the commit conventions and the release flow. -->
