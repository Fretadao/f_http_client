# Changelog

## [0.4.0](https://github.com/Fretadao/f_http_client/compare/v0.3.0...v0.4.0) (2026-08-20)


### ⚠ BREAKING CHANGES

* the FService matchers compare the type list for equality, so specs asserting have_failed_with(:unprocessable_entity, :client_error) now need have_failed_with(:unprocessable_content, :unprocessable_entity, :client_error). Runtime is unaffected — on_failure matches by inclusion. Seven specs across apps/router and apps/web need this adjustment.

### Features

* expose RFC 9110 status type aliases for 422 and 413 [CU-86ak35ptc] ([#37](https://github.com/Fretadao/f_http_client/issues/37)) ([277ac96](https://github.com/Fretadao/f_http_client/commit/277ac966c1aad874839445066cc251d2f3ea09e5))

## [0.3.0] - 2026-08-19

- Add `f_http_client_response_including` RSpec matcher for testing HTTParty::Response objects with nested matchers
- Fix Ruby 4.0+ compatibility by adding activesupport >= 7.2, ostruct, and csv dependencies
- Change Disable rubygems MFA checking #14

## [0.2.1] - 2023-09-27

- Add rescue to SocketError exception. #12

## [0.2.0] - 2023-05-22

- Add FService as runtime dependency.

## [0.1.0] - 2023-02-13

- Initial release
- Add Caching strategies;
- Add Logging strategies;
- Add Custom parse for JSON responses;
- Add Response and Exception processors;
- Add Base client class;
- Add Basic configuration;
- Add RSpec helpers to simulate responses
