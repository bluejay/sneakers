module Sneakers
  module Deferrable
  
    def task(&block)
      callback = Proc.new do |result|
        @fiber.resume result
      end
      EM::defer(block, callback)
      Fiber.yield
    end
    
    def async_task(operation, callback)
      EM::defer(operation, callback)
    end

  end
end