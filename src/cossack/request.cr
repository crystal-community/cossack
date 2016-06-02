module Cossack
  class Request
    @method : Symbol
    @uri : URI
    @params : Params
    @headers : HTTP::Headers

    property :method, :uri, :params, :headers

    def initialize(@method : Symbol, @uri : URI, @headers : HTTP::Headers, @params : Params)
    end
  end
end
