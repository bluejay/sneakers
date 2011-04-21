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
      if operation.nil?
        operation = block if block_given?
      elsif callback.nil?
        callback = block if block_given?
      end

      callback = Proc.new{} if callback.nil?
      
      EM::defer(operation, callback)
    end

  end
end