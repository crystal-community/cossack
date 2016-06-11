module Cossack
  class Request
    @method : String
    @uri : URI
    @headers : HTTP::Headers
    @body : String?
    @options : RequestOptions

    property :method, :uri, :headers, :body, :options

    def initialize(@method : String, @uri : URI, @headers : HTTP::Headers, @body : String? = nil)
      @options = RequestOptions.new
    end
  end
end
