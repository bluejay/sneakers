require "fiber"

module Sneakers
  class Application
    include Sneakers::Controller
    
    def initialize(&block)
      @block = block
    end

    def run
      instance_eval(&@block)
    end
  end
end