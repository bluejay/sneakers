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

    # Creates a duplicate of the controller for each request.
    def call(env, *args)
      dup.call!(env, *args)
    end

    # Call the action.
    def call!(env, *args)
      # A preprocessing method
      before_call() if respond_to?(:before_call)
      
      # Determines the action to be called
      klass = self.class
      action = env[klass.env_action_key] || @action || :index
      
      # Sets the instance variables, especially the response
      @env      = env
      @response = Sneakers::Response.new(env)
      
      # A fiber wrapper for the action
      @fiber = Fiber.new do
        # Call the action
        if respond_to?(action)
          __send__(action, *args)
          
        # 404 methods
        elsif respond_to?(:not_found)
          @response.status = 404
          not_found()
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

    # Allow for the use of a specific has key to determine the action.
    module ClassMethods
      attr_reader :env_action_key
      
      def action_key(hash_key)
        @env_action_key = hash_key
      end
      
      def self.extended(base)
        base.action_key 'sneakers.action'
      end
    end


    def self.included(base)
      base.instance_eval do
        include Sneakers::Logger
        extend(ClassMethods)
      end
    end
  end
end
