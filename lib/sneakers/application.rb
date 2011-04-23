module Sneakers
  class Application
    include Sneakers::Controller
    
    # The rack environment.
    #
    # @return [Hash]
    attr_accessor :env
    
    # The request.
    #
    # @return [Rack::Request]
    attr_accessor :request
    
    def initialize(&block)
      @block = block
    end
    
    def index
      @request = Rack::Request.new(@env)
      instance_eval(&@block)
    end
  end
end