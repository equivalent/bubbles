module Bubbles
  module CommonUploaderInterface
    def self.included(base)
      base.send(:attr_reader, :config, :command_queue, :bfile)
    end

    def initialize(bfile:, command_queue:, config:)
      @bfile  = bfile
      @config = config
      @command_queue = command_queue
    end
  end
end
