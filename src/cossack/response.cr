module Cossack
  class Response
    getter :status, :headers, :body

    def self.null_response
      @@null_response = new(0, HTTP::Headers.new, "")
    end

    def initialize(@status : Int32, @headers : HTTP::Headers, @body : String)
    end

    def initialize(@status : Int32, headers : Hash(String, String), @body : String)
      @headers = HTTP::Headers.new
      headers.each { |name, val| @headers[name] = val }
    end

    def initialize(@status : Int32, @body : String)
      @headers = HTTP::Headers.new
    end

    # Returns true if the response status is between 200 and 299
    def success?
      (200..299).includes?(status)
    end
  end
end
