module Cossack
  class HttpAdapter < Adapter
    def call(env : Env) : Env
      request = env.request
      http_response = HTTP::Client.exec(request.method.to_s.upcase, request.uri, request.headers, request.body)
      response = Response.new(http_response.status_code, http_response.headers, http_response.body)
      env.response = response
      env
    end
  end
end
