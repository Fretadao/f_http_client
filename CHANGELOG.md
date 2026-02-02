## [Unreleased]

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
