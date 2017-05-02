# Faultline::Rack [![Build Status](https://travis-ci.org/faultline/faultline-rack.svg?branch=master)](https://travis-ci.org/faultline/faultline-rack)

> [faultline](https://github.com/faultline/faultline) exception and error notifier for Rack application.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'faultline-rack'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install faultline-rack

## Usage

config/application.rb

```ruby
require 'faultline/rack'

Faultline.configure do |c|
  c.project = 'faultline-rack'
  c.api_key = 'xxxxXXXXXxXxXXxxXXXXXXXxxxxXXXXXX'
  c.endpoint = 'https://xxxxxxxxx.execute-api.ap-northeast-1.amazonaws.com/v0'
  c.notifications = [
    {
      type: 'slack',
      endpoint: 'https://hooks.slack.com/services/XXXXXXXXXX/B2RAD9423/WC2uTs3MyGldZvieAtAA7gQq',
      channel: '#random',
      username: 'faultline-notify',
      notifyInterval: 1,
      threshold: 1,
      timezone: 'Asia/Tokyo'
    },
    {
      type: 'github',
      userToken: 'XXXXXXXxxxxXXXXXXxxxxxXXXXXXXXXX',
      owner: 'k1LoW',
      repo: 'faultline',
      labels: [
        'faultline', 'bug'
      ],
      if_exist: 'reopen-and-comment',
      notifyInterval: 1,
      threshold: 1,
      timezone: 'Asia/Tokyo'
    }
  ]
end

[...]

module MyApp
  class Application < Rails::Application
    config.middleware.use Faultline::Rack::Middleware
  end
end
```

## References

- [airbrake/airbrake](https://github.com/airbrake/airbrake)
    - Airbrake is licensed under [The MIT License (MIT)](https://github.com/airbrake/airbrake/LICENSE.md).

## License

MIT © Ken&#39;ichiro Oyama
