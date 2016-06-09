module Cossack
  class HttpConnection < Connection
    def initialize(@connect_timeout : Float64, @read_timeout : Float64)
    end

    def call(request : Request) : Response
      client = HTTP::Client.new(request.uri)
      client.connect_timeout = @connect_timeout
      client.read_timeout = @read_timeout

      http_response = client.exec(request.method, request.uri.to_s, request.headers, request.body)
      Response.new(http_response.status_code, http_response.headers, http_response.body)
    rescue err : IO::Timeout
      raise TimeoutError.new(err.message, cause: err)
    end
  end
end
