# Qyu::Queue::SQS

[![Gem Version](https://img.shields.io/gem/v/qyu-queue-sqs.svg)](https://rubygems.org/gems/qyu-queue-sqs)
[![Build Status](https://travis-ci.org/FindHotel/qyu-queue-sqs.svg)](https://travis-ci.org/FindHotel/qyu-queue-sqs)

## Requirements:

* Ruby 2.4.0 or newer

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'qyu-queue-sqs'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install qyu-queue-sqs

## Configuration

To start using Qyu; you need a queue configuration and a state store configuration. Here's an example:
```ruby
require 'qyu'
require 'qyu/queue/sqs'

Qyu.configure(
  queue: {
    type: :sqs,
    region: aws_region,
    access_key_id: aws_access_key_id,
    secret_access_key: aws_secret_access_key,
    queue_prefix: queue_prefix, # example: production
    # Optional
    message_retention_period: 1_209_600,
    message_visibility_timeout: 300,
    maximum_message_size: 262_144
  },
  store: {
    type: :memory
    # Or one of the other production-ready queues available
    # Check https://github.com/FindHotel/qyu/wiki/State-Stores
  },
  # optional Defaults to STDOUT
  logger: Logger.new(STDOUT)
)
```

## Usage

TODO: Write usage instructions here

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/qyu-queue-sqs. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Qyu::Queue::SQS project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/qyu-queue-sqs/blob/master/CODE_OF_CONDUCT.md).
