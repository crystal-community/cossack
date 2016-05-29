module Cossack
  class Response
    getter :status, :headers, :body

    def initialize(@status : Int32, @headers : HTTP::Headers, @body : String)
    end
  end
end
