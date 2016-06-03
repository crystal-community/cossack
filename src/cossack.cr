require "http"
require "uri"

require "./cossack/**"

module Cossack
  alias Params = Hash(String, String)

  class Error < Exception; end

  {% for method in %w(get post put) %}
    def self.{{method.id}}(*args)
      default_client.{{method.id}}(*args)
    end

    def self.{{method.id}}(*args, &block : Request -> _)
      default_client.{{method.id}}(*args, &block)
    end
  {% end %}

  def self.default_client
    @@default_client ||= Client.new
  end
end
