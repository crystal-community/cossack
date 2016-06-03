module Cossack
  class Request
    @method : Symbol
    @uri : URI
    @headers : HTTP::Headers

    property :method, :uri, :params, :headers, :body

    def initialize(@method : Symbol, @uri : URI, @headers : HTTP::Headers, @body : String = "")
    end
  end
end
