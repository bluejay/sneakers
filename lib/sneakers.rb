module Sneakers
  ROOT = File.join(File.dirname(__FILE__), "sneakers")

  autoload :Logger,       "#{ROOT}/logger.rb"
  autoload :Application,  "#{ROOT}/application.rb"
  autoload :Deferrable,   "#{ROOT}/deferrable.rb"
  autoload :Response,     "#{ROOT}/response.rb"
end