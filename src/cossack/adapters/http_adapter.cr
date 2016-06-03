module Cossack
  class HttpAdapter < Adapter
    def call(env : Env) : Env
      if env.request.method == :get
        env.response = get(env.request)
      elsif env.request.method == :post
        env.response = post(env.request)
      elsif env.request.method == :put
        env.response = put(env.request)
      elsif env.request.method == :patch
        env.response = patch(env.request)
      elsif env.request.method == :delete
        env.response = delete(env.request)
      else
        raise(Error.new("Cossack::HttpAdapter: Not supported HTTP method `#{env.request.method}`"))
      end

      env
    end

    def get(request) : Response
      query = HTTP::Params.build do |form|
        request.params.each { |name, val| form.add(name, val) }
      end
      uri = request.uri.clone
      uri.query = query

      http_response = HTTP::Client.get(uri, request.headers)
      Response.new(http_response.status_code, http_response.headers, http_response.body)
    end

    def post(request) : Response
      http_response = HTTP::Client.post(request.uri, request.headers, request.body)
      Response.new(http_response.status_code, http_response.headers, http_response.body)
    end

    def put(request) : Response
      http_response = HTTP::Client.put(request.uri, request.headers, request.body)
      Response.new(http_response.status_code, http_response.headers, http_response.body)
    end

    def patch(request) : Response
      http_response = HTTP::Client.patch(request.uri, request.headers, request.body)
      Response.new(http_response.status_code, http_response.headers, http_response.body)
    end

    def delete(request) : Response
      http_response = HTTP::Client.delete(request.uri, request.headers, request.body)
      Response.new(http_response.status_code, http_response.headers, http_response.body)
    end
  end
end
