require 'fileutils'
require 'pathname'
require 'logger'
require 'securerandom'
require 'yaml'
require 'forwardable'
require "bubbles/version"
require "bubbles/config"
require "bubbles/command_queue"
require "bubbles/bubblicious_file"
require "bubbles/dir_watcher"
require "bubbles/uploaders/s3"
require "bubbles/uploaders/local_dir"


module Bubbles
  extend self

  def config
    @config ||= Config.new
  end

  def run
    command_queue = Bubbles::CommandQueue.new

    command_queue << Bubbles::DirWatcher.new({
      source_dir: config.source_dir,
      processing_dir: config.processing_dir,
      command_queue: command_queue,
      uploader_classes: config.uploader_classes,
    })

    loop do
      command_queue.call_next
      sleep config.sleep_interval
    end
  end

  def logger
    config.logger
  end
end
