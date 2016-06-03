module Cossack
  class Client
    USER_AGENT = "Cossack v#{VERSION}"

    @base_uri : URI
    @headers : HTTP::Headers
    @app : HttpAdapter|Middleware

    getter :base_uri, :headers

    def initialize(base_url = nil)
      @headers = default_headers
      @app = HttpAdapter.new

      if base_url
        @base_uri = URI.parse(base_url)
      else
        @base_uri = URI.new
      end

      yield self
    end

    # With block given...
    def initialize(base_url = nil)
      @headers = default_headers
      @app = HttpAdapter.new

      if base_url
        @base_uri = URI.parse(base_url)
      else
        @base_uri = URI.new
      end
    end


    def add_middleware(md : Middleware)
      md.app = @app
      @app = md
    end

    def get(url_or_path : String, params : Params = Params.new) : Response
      get(url_or_path, params) { }
    end

    def get(url_or_path : String, params : Params = Params.new) : Response
      uri = complete_uri!(URI.parse(url_or_path))
      request = Request.new(:get, uri, @headers.clone, params)
      yield(request)
      env = Env.new(request)
      @app.call(env).response as Response
    end


    def post(url_or_path : String, body : String = "")
      post(url_or_path, body) { }
    end

    def post(url_or_path : String, body : String = "")
      uri = complete_uri!(URI.parse(url_or_path))
      request = Request.new(:post, uri, @headers.clone, Params.new, body)
      yield(request)
      env = Env.new(request)
      @app.call(env).response as Response
    end


    def put(url_or_path : String, body : String = "")
      put(url_or_path, body) { }
    end

    def put(url_or_path : String, body : String = "")
      uri = complete_uri!(URI.parse(url_or_path))
      request = Request.new(:put, uri, @headers.clone, Params.new, body)
      yield(request)
      env = Env.new(request)
      @app.call(env).response as Response
    end

    def patch(url_or_path : String, body : String = "")
      patch(url_or_path, body) { }
    end

    def patch(url_or_path : String, body : String = "")
      uri = complete_uri!(URI.parse(url_or_path))
      request = Request.new(:patch, uri, @headers.clone, Params.new, body)
      yield(request)
      env = Env.new(request)
      @app.call(env).response as Response
    end

    def delete(url_or_path : String, body : String = "")
      delete(url_or_path, body) { }
    end

    def delete(url_or_path : String, body : String = "")
      uri = complete_uri!(URI.parse(url_or_path))
      request = Request.new(:delete, uri, @headers.clone, Params.new, body)
      yield(request)
      env = Env.new(request)
      @app.call(env).response as Response
    end


    private def default_headers
      HTTP::Headers.new.tap do |headers|
        headers["User-Agent"] = USER_AGENT
      end
    end

    # Add missing part of URI from the base URI.
    private def complete_uri!(uri)
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
