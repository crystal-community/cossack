require "http"

require "./cossack/**"

module Cossack
  def self.new(*args) : Connection
    Cossack::Connection.new(*args)
  end
end
