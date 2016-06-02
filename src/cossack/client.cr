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
      uri = complete_uri!(URI.parse(url_or_path))
      request = Request.new(:get, uri, @headers.clone, params)
      env = Env.new(request)
      @app.call(env).response as Response
    end

    # Overload with block
    def get(url_or_path : String, params : Params = Params.new) : Response
      uri = complete_uri!(URI.parse(url_or_path))
      request = Request.new(:get, uri, default_headers, params)
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
