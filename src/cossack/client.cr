module Cossack
  class Client
    @base_uri : URI
    @app : HttpAdapter|Middleware

    def initialize(base_url = nil)
      if base_url
        @base_uri = URI.parse(base_url)
      else
        @base_uri = URI.new
      end

      @middlewares = [] of Middleware
      @app = HttpAdapter.new
      yield self
    end

    # TODO: refactor duplications
    def initialize(base_url = nil)
      if base_url
        @base_uri = URI.parse(base_url)
      else
        @base_uri = URI.new
      end

      @middlewares = [] of Middleware
      @app = HttpAdapter.new
    end


    def add_middleware(md : Middleware)
      md.app = @app
      @app = md
    end

    def get(url_or_path : String, params : Hash(String, String) = {} of String => String) : Response
      uri = complete_uri!(URI.parse(url_or_path))

      puts uri.to_s

      request = Request.new(:get, uri.to_s, params)
      env = Env.new(request)
      @app.call(env).response as Response
    end

    # Add missing part of URI from the base URI.
    def complete_uri!(uri)
      uri.scheme ||= @base_uri.scheme
      uri.host ||= @base_uri.host
      uri.port ||= @base_uri.port
      uri.user ||= @base_uri.user
      uri.password ||= @base_uri.password

      # It's a work around.
      # TODO: implement URI.join method and open PR in Crystal
      if @base_uri.path
        uri.path = File.join(@base_uri.path.to_s, uri.path.to_s)
      end

      uri
    end
  end
end
