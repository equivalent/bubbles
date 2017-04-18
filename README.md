# Bubbles

[![Build Status](https://travis-ci.org/equivalent/bubbles.svg?branch=master)](https://travis-ci.org/equivalent/bubbles)

Daemonized file uploader that watch a folder and uploads any files files
to AWS S3. Designed for Raspberry pi zero


Notes:


* for AWS S3 upload we use AWS-SDK [s3 put_object](http://docs.aws.amazon.com/sdkforruby/api/Aws/S3/Client.html#put_object-instance_method) the single file upload should not exceed 5GB.
I'm not planing to introduce S3 multipart uploads but Pull Requests are welcome.


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

create `~/.bubbles/config.yml` and set conf options
(`lib/bubbles/configuration`)

Better how to soon


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.
To install this gem onto your local machine, run `bundle exec rake install`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/equivalent/bubbles.


