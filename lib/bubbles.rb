require 'fileutils'
require 'pathname'
require "bubbles/version"
require "bubbles/command_queue"
require "bubbles/bubblicious_file"
require "bubbles/dir_watcher"

module Bubbles
  extend self

  def run
    command_queue = Bubbles::CommandQueue.new
    source_dir = '/tmp/foo'
    processing_dir = '/tmp/bar'

    dir_watcher = Bubbles::DirWatcher.new({
      source_dir: source_dir,
      processing_dir: processing_dir,
      command_queue: command_queue,
      uploader_classes: [],
    })

    command_queue << dir_watcher

    loop do
      command_queue.call_next
      sleep 1
    end
  end
end
