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
      elsif env.request.method == :head
        env.response = head(env.request)
      elsif env.request.method == :options
        env.response = options(env.request)
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

    macro define_http_methods(names)
      {% for name, index in names %}
        def {{name}}(request) : Response
          http_response = HTTP::Client.{{name}}(request.uri, request.headers, request.body)
          Response.new(http_response.status_code, http_response.headers, http_response.body)
        end
      {% end %}
    end

    define_http_methods [post, put, delete, patch, head]

    def options(request) : Response
      http_response = HTTP::Client.exec("OPTIONS", request.uri, request.headers)
      Response.new(http_response.status_code, http_response.headers, http_response.body)
    end
  end
end
