module Sneakers
  ROOT = File.join(File.dirname(__FILE__), "sneakers")

  autoload :Logger,       "#{ROOT}/logger.rb"  
  autoload :Response,     "#{ROOT}/response.rb"
end