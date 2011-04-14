require 'logger'

module Sneakers
  module Logger
    
    class << self
      attr_accessor :silent, :hushed, :location
      
      @silent = false
      @hushed = false
      
      def silent?; silent; end
      def hushed?; hushed; end
    end
    
    def self.included(base)
      logger = ::Logger.new(Sneakers::Logger.location ||= $stdout)
      logger.level = ::Logger::DEBUG
      logger.formatter = Sneakers::Logger::Formatter.new(base)
      
      base.instance_eval do
        @logger = logger
        
        def logger
          @logger
        end
      end
    end
  
    def log
      self.class.logger
    end
  
    class Formatter < ::Logger::Formatter
      def initialize(name)
        @name
      end
      
      def call(severity, time, program, msg)
        unless Sneakers::Logger.silent? or (Sneakers::Logger.hushed? and not severity == "ERROR")
          calling_method = caller(4).first.match(/(?<=:in `).*(?=')/)[0]
          "[#{severity.upcase}] from #{@name} at #{calling_method} at #{time}: #{msg}\n"
        end
      end
    end  
  end
end