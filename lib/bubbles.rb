require 'fileutils'
require 'pathname'
require 'logger'
require 'securerandom'
require 'yaml'
require 'forwardable'
require 'aws-sdk'
require "bubbles/version"
require "bubbles/config"
require "bubbles/command_queue"
require "bubbles/bubblicious_file"
require "bubbles/dir_watcher"
require 'bubbles/common_uploader_interface'
require "bubbles/uploaders/s3"
require "bubbles/uploaders/local_dir"

module Bubbles
  extend self

  def config
    @config ||= Config.new
  end

  def run
    command_queue = Bubbles::CommandQueue.new(config: config)

    command_queue << Bubbles::DirWatcher.new({
      config: config,
      command_queue: command_queue
    })

    loop do
      command_queue.call_next
      sleep config.sleep_interval
    end
  end
end
