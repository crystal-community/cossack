module Cossack
  # Request built by Client, that can be processed by middleware and a connection.
  #
  # ```
  # request.method  # => "POST"
  # request.uri     # => #<URI:0x11b8ea0 @scheme="http", @host="example.org" ...>
  # request.body    # => "payload"
  # request.headers # => #<HTTP::Headers ... >
  # request.options.connect_timeout  # => 30
  # request.options.read_timeout     # => 30
  # ```
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
