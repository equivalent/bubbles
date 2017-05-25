# Bubbles

[![Build Status](https://travis-ci.org/equivalent/bubbles.svg?branch=master)](https://travis-ci.org/equivalent/bubbles)

Daemonized file uploader that watch a folder and uploads any files files
to AWS S3 or Local directory (e.g. mounted NAS volume). Designed for Raspberry pi zero


Notes:

* for AWS S3 upload we use AWS-SDK [s3 put_object](http://docs.aws.amazon.com/sdkforruby/api/Aws/S3/Client.html#put_object-instance_method) the single file upload should not exceed 5GB. I'm not planing to introduce S3 multipart uploads but Pull Requests are welcome.


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

##### The easy way

Gem by default looks into to two locations for configuration file. So
either create `~/.bubbles/config` or `/var/lib/bubbles/config.yml`

> note: make sure you have correct read access permission so that ruby
> can read that file

...with content similar to this:

```yml
s3_access_key_id:  xxxxxxxxxxxxxxxxxxxx
s3_secret_access_key: yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy
s3_bucket: bucket_name
s3_region: eu-west-1

source_dir: /home/myuser/source_folder
processing_dir: /home/myuser/processing_folder
```

Now all is left is to lunch bubbles with  `bubbles` or `bundle exec bubbles`

> note: files in `source_folder` will get removed after successful upload 

##### More advanced config


```yml
source_dir: /var/myuser/source_folder              # source from where to pick up files
processing_dir: /home/myuser/processing_folder

log_level: 0                                       # debug log level
log_path: /var/log/bubbles.log                     # default is STDOOT

sleep_interval: 1                                  # sleep between next command
num_of_files_to_schedule: 1                        # how many files schedule for processing at the same time

uploaders:
  - 'Bubbles::Uploaders::S3'                       # by default only S3 uploader is used
  - 'Bubbles::Uploaders::LocalDir'

s3_access_key_id:  xxxxxxxxxxxxxxxxxxxx
s3_secret_access_key: yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy
s3_bucket: bucket_name
s3_region: eu-west-1
s3_path: foo_folder/bar_folder/car_folder          # will upload to s3://bucket/foo_folder/bar_folder/car_folder
s3_acl: private                                    # # accepts private, public-read, public-read-write, authenticated-read, aws-exec-read, bucket-owner-read, bucket-owner-full-control

local_dir_uploader_path: /mnt/network_smb_storage
local_dir_metadata_file_path /var/log/uploads_metadata.yaml
```

> Look into [lib/bubbles/config.rb](https://github.com/equivalent/bubbles/blob/master/lib/bubbles/config.rb) for more details.

##### Full Ruby way

You can create custom ruby file and you initialize custom
`Bubbles::Config.new` instance and set all the options you want there:

```ruby
# ~/my_bubbles_runner.rb
require 'bubbles'

c = Bubbles::Config.new

c.log_level = 0
c.source_dir = /var/myuser/source_folder
c.processing_dir = /var/myuser/processing_folder
c.uploader_classes = [Bubbles::Uploaders::S3, Bubbles::Uploaders::LocalDir]
c.local_dir_uploader_path = /mnt/network_smb_storage
c.s3_region = 'eu-west-1'
c.s3_bucket = 'mybckt'
c.s3_access_key_id     = 'xxxxxxxxxxx'
c.s3_secret_access_key = 'yyyyyyyyyyy'

# ...

command_queue = Bubbles::CommandQueue.new(config: c)
command_queue << Bubbles::DirWatcher.new(config: c, command_queue: command_queue)

loop do
  command_queue.call_next
  sleep c.sleep_interval
end
```

..and execute:

```sh
ruby my_bubbles_runner.rb
# or
bundle exec ruby my_bubbles_runner.rb
```

> Look into [lib/bubbles/config.rb](https://github.com/equivalent/bubbles/blob/master/lib/bubbles/config.rb) for more details.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.
To install this gem onto your local machine, run `bundle exec rake install`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/equivalent/bubbles.


