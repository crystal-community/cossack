module Cossack
  class TestConnection < Connection
    class RequestMatcher
      def initialize(@method : String? = nil, uri : URI?|String? = nil, @headers = {} of String => String, @body : String? = nil)
        @uri = uri ? URI.parse(uri) : URI.new
      end

      def matches?(request : Request)
        return false if @method && @method != request.method
        return false if @body   && @body   != request.body

        {% for uri_part in %w(scheme host port user password path query) %}
          return false if @uri.{{uri_part.id}} && @uri.{{uri_part.id}} != request.uri.{{uri_part.id}}
        {% end %}

        @headers.each do |name, value|
          return false unless request.headers[name]? == value
        end

        true
      end
    end
  end
end
