# Bubbles

[![Build Status](https://travis-ci.org/equivalent/bubbles.svg?branch=master)](https://travis-ci.org/equivalent/bubbles)

Daemonized file uploader that watch a folder and uploads any files files
to AWS S3. Designed for Raspberry pi zero


Notes:


* for AWS S3 upload we use AWS-SDK [s3 put_object](http://docs.aws.amazon.com/sdkforruby/api/Aws/S3/Client.html#put_object-instance_method) the single file upload should not exceed 5GB.
I'm not planing to introduce S3 multipart uploads but Pull Requests are welcome.

Development in progress

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'bubbles'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install bubbles

## Usage

TODO: Write usage instructions here

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/bubbles.


