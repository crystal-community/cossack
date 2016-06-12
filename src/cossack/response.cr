module Cossack
  # Represents HTTP response.
  #
  # ```crystal
  # response = Cossack::Response.new(204, {"Content-Length" => "20"}, "Saluton Esperantujo!")
  #
  # response.status                    # => 204
  # response.headers["Content-Length"] # => "20"
  # response.body                      # => "Saluton Esperantujo!"
  #
  # response.success?      # => true
  # response.redirection?  # => false
  # response.client_error? # => false
  # response.server_error? # => false
  # ```
  class Response
    getter :status, :headers, :body

    def initialize(@status : Int32, @headers : HTTP::Headers, @body : String)
    end

    def initialize(@status : Int32, headers : Hash(String, String), @body : String)
      @headers = HTTP::Headers.new
      headers.each { |name, val| @headers[name] = val }
    end

    def initialize(@status : Int32, @body : String)
      @headers = HTTP::Headers.new
    end


    # Is this a 2xx response?
    def success?
      (200..299).includes?(status)
    end

    # # Is this a 3xx redirect?
    def redirection?
      (300..399).includes?(status)
    end

    # # Is this is a 4xx response?
    def client_error?
      (400..499).includes?(status)
    end

    # Is this a 5xx response?
    def server_error?
      (500..599).includes?(status)
    end
  end
end
