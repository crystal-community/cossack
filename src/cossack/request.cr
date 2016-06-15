module Cossack
  class Request
    @method : String
    @uri : URI
    @headers : HTTP::Headers
    @body : String?
    @options : RequestOptions

    property :method, :uri, :headers, :body, :options

    def initialize(@method : String, @uri : URI, @headers : HTTP::Headers = HTTP::Headers.new, @body : String? = nil, @options = RequestOptions.new)
    end

    def initialize(@method : String, uri : String, @headers : HTTP::Headers = HTTP::Headers.new, @body : String? = nil, @options = RequestOptions.new)
      @uri = URI.parse(uri)
    end
  end
end
