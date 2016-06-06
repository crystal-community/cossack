require "http"
require "uri"

require "./cossack/**"

module Cossack
  alias Params = Hash(String, String)

  class Error < Exception; end

  @@default_client = Client.new

  {% for method in %w(get post put patch delete head options) %}
    def self.{{method.id}}(*args)
      @@default_client.{{method.id}}(*args)
    end

    def self.{{method.id}}(*args, &block : Request -> _)
      @@default_client.{{method.id}}(*args, &block)
    end
  {% end %}
end
