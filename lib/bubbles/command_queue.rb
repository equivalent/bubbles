module Bubbles
  class CommandQueue
    def initialize(config:)
      @config = config
    end

    def queue
      @queue ||= []
    end

    def <<(command_object)
      queue << command_object
    end

    def call_next
      queue.shift.tap {|c| log c}.call
    end

    def reschedule(command_object)
      queue.unshift(command_object)
    end

    private
      attr_reader :config

      def log(command)
        config.logger.debug("Processing: #{command.inspect}")
      end
  end
end
