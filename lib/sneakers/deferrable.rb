module Sneakers
  module Deferrable
  
    def task(&block)
      callback = Proc.new do |result|
        @fiber.resume result
      end
      EM::defer(block, callback)
      Fiber.yield
    end
    
    def async_task(operation = nil, callback= nil, &block)
      # Smartly determines what the block is for.
      if not operation
        operation = block if block
      elsif not callback
        callback = block if block
      end

      callback = Proc.new unless callback
      
      EM::defer(operation, callback)
    end

  end
end