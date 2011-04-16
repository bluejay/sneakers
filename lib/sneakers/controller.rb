require "fiber"

module Sneakers
  module Controller
    include Sneakers::Logger
    include Sneakers::Deferrable

    # The response.
    #
    # @return [Sneakers::Reponse]
    attr_accessor :response
    
    # The fiber in which the action happens.
    #
    # @return [Fiber]
    attr_accessor :fiber

    # Call the action.
    def __call__(env, *args)
      action = env['sneakers.action'] || @action
      @response = Sneakers::Response.new(env)
      
      # A fiber wrapper for the action
      @fiber = Fiber.new do
        # Call the action
        if respond_to?(action)
          __send__(action, *args)
        elsif respond_to?(:not_found) then not_found()
        else 
          @response.status = 404
          @response.header.merge!({'Content-Type' => "text/html"})
          @response.body   = "Could not find page"
        end
        
        # Complete the request
        @response.done
      end
      
      # Call the fiber 
      @fiber.resume
      
      # throw :async
      @response.finish
    end    

    alias call __call__

    # Defers the response.
    def defer_response(*args)
      @response.defer
    end
  
    # Finishes a response, should be used for deferrables.
    def finish
      @response.complete
    end
  
    # Sends data to the body of the response.
    def send(data)
      @response.write(data)
    end

    def self.included(base)
      base.instance_eval do
        include Sneakers::Logger
      end
    end
  end
end
