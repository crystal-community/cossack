module Cossack
  class Request
    @method : String
    @uri : URI
    @headers : HTTP::Headers
    @body : String?

    property :method, :uri, :params, :headers, :body

    def initialize(@method : String, @uri : URI, @headers : HTTP::Headers, @body : String|Nil = nil)
    end
  end
end
