module Sneakers
  ROOT = File.join(File.dirname(__FILE__), "sneakers")

  require "rack"
  require "fiber"
  require "logger"

  autoload :Logger,       "#{ROOT}/logger.rb"
  autoload :Application,  "#{ROOT}/application.rb"
  autoload :Deferrable,   "#{ROOT}/deferrable.rb"
  autoload :Response,     "#{ROOT}/response.rb"
end

def Sneakers(&action)
  return Proc.new do |env|
    application = Sneakers::Application.new(env)
    application.__call__(&action)
  end
end