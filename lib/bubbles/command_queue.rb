class Bubbles::CommandQueue
  def queue
    @queue ||= []
  end

  def <<(command_object)
    queue << command_object
  end

  def call_next
    queue.shift.call
  end
end
