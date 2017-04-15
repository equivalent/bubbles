module Bubbles
  class CommandQueue
    def queue
      @queue ||= []
    end

    def <<(command_object)
      queue << command_object
    end

    def call_next
      queue.shift.tap {|c| log c}.call
    end

    private
      def log(command)
        Bubbles.logger.debug("Processing: #{command.inspect}")
      end
  end
end
