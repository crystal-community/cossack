module Cossack
  class Response
    getter :status, :headers, :body

    def self.null_response
      @@null_response = new(0, HTTP::Headers.new, "")
    end

    def initialize(@status : Int32, @headers : HTTP::Headers, @body : String)
    end
  end
end
