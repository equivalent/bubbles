module Bubbles
  class CommandQueue
    def queue
      @queue ||= []
    end

    def <<(command_object)
      queue << command_object
    end

    def call_next
      queue.shift.tap {|c| p c}.call
    end
  end
end
