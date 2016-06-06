module Cossack
  class HttpConnection < Connection
    def call(request : Request) : Response
      http_response = HTTP::Client.exec(request.method, request.uri, request.headers, request.body)
      Response.new(http_response.status_code, http_response.headers, http_response.body)
    end
  end
end
