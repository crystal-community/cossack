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
      params_str = HTTP::Params.build do |form|
        request.params.each { |name, val| form.add(name, val) }
      end
      url = "#{request.url}?#{params_str}"
      http_response = HTTP::Client.get(url)

      Response.new(http_response.status_code, http_response.headers, http_response.body)
    end
  end
end
