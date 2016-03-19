# Pup

A simple webserver, built as a learning exercise for HTTP and TCP.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'pup'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install pup

## Usage

```ruby
$ pup --port=8808
2016-03-19 20:14:33 +0000 | Pup::Server listening on port 8808
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake rspec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/pup.

