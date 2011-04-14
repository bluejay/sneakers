module Sneakers
  class DeferrableBody
    include EventMachine::Deferrable
    
    def call(data)
      @callback.call(data)
    end
  
    def each(&block)
      @callback = block
    end
  end

  class Response < Rack::Response
    def initialize(env)
      # Default Values for a response
      @status = 200
      @header = Rack::Utils::HeaderHash.new("Content-Type" =>"text/html; charset=utf-8")
      @body   = [] # Defaults to a regular body
      
      # Other attributes of the response
      @writer = lambda { |x| self.body << x    }
      @length = 0 # Content-Length
      @deferred = false
      
      @callback = env['async.callback']
      
      yield self if block_given?
    end
    
    def deferred?
      @deferred
    end
    
    def defer
      @deferred = true
      @body = Sneakers::DeferrableBody.new   
      @writer = lambda { |x| @body.call(x) }
      @callback.call([status, header, body])
    end
    
    def write(str)
      @writer.call(str.to_s)
    end
    
    def done
      unless @deferred      
        if [204, 304].include?(status.to_i)
          header.delete "Content-Type"
          @callback.call([status, header, []])
        else
          @callback.call([status.to_i, header, body])
        end
      end
    end
    
    def complete(&block)
      @deferred ? 
        body.succeed : done
    end
    
    def finish
      throw :async
    end
  end
end