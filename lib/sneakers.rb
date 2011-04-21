module Sneakers
  ROOT = File.join(File.dirname(__FILE__), "sneakers")

  require "rack"
  require "eventmachine"
  require "fiber"
  require "logger"

  autoload :Logger,       "#{ROOT}/logger.rb"
  autoload :Application,  "#{ROOT}/application.rb"
  autoload :Controller,   "#{ROOT}/controller.rb"
  autoload :Deferrable,   "#{ROOT}/deferrable.rb"
  autoload :Response,     "#{ROOT}/response.rb"
end

def sneakers(&action)
  return Sneakers::Application.new(&action)
end

alias Sneakers sneakers