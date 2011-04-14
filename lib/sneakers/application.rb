require "fiber"

module Sneakers
  class Application
    include Sneakers::Logger
    include Sneakers::Deferrable
    
    # The request.
    #
    # @return [Rack::Request]
    attr_accessor :request
    
    # The response.
    #
    # @return [Sneakers::Response]
    attr_accessor :response
    
    def initialize(env, *args, &block)
      # The incoming request
      @request = Rack::Request.new(env)
      
      # The Defaults for the Response
      @response = Sneakers::Response.new(env)
    end
    
    def __call__(&block)
      # A fiber wrapper for the action's being called
      @fiber = Fiber.new do
        instance_eval(&block)
        @response.done
      end 
      
      # Call the fiber
      @fiber.resume
      
      @response.finish
    end
  
    def defer_response(*args)
      @response.defer
    end
  
    def finish
      @response.complete
    end
  
    # Only use if response is deferred
    def send(data)
      @response.write(data)
    end

    def self.inherited(base)
      base.instance_eval do
        include Sneakers::Logger
      end
    end
    
  end
end