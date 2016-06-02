module Cossack
  class HttpAdapter < Adapter
    def call(env : Env) : Env
      if env.request.method == :get
        env.response = get(env.request)
        env
      else
        raise("Cossack::HttpAdapter: Not support HTTP method `#{env.request.method}`")
      end
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
  end
end
