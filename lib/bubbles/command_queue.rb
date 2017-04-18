module Bubbles
  class CommandQueue
    extend Forwardable

    def_delegators :queue, :size

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
      if command = queue.shift
        log command
        command.call
      else
        log "Nothing in the command queue"
      end
    end

    def reschedule(command_object)
      queue.unshift(command_object)
    end

    def inspect
      "<##{self.class.name} queue:#{queue.inspect} >"
    end

    private
      attr_reader :config

      def log(command)
        config.logger.debug("Processing: #{command.inspect}")
      end
  end
end
