module Cossack
  class Client
    USER_AGENT = "Cossack v#{VERSION}"

    @base_uri : URI
    @headers : HTTP::Headers
    @app : Middleware

    getter :base_uri, :headers

    def initialize(base_url = nil)
      @headers = default_headers

      @connection_middleware = ConnectionMiddleware.new(HttpConnection.new)
      @app = @connection_middleware

      if base_url
        @base_uri = URI.parse(base_url)
      else
        @base_uri = URI.new
      end

      yield self
    end

    # When block is not given.
    def initialize(base_url = nil)
      initialize(base_url) { }
    end

    def add_middleware(md : Middleware)
      md.app = @app
      @app = md
    end

    def connection=(connection : Proc(Request, Response)|Connection)
      @connection_middleware.connection = connection
    end

    def set_connection(&block : Request -> Response)
      @connection_middleware.connection = block
    end

    def connection
      @connection_middleware.connection
    end

    {% for method in %w(get delete head options) %}
      def {{method.id}}(url_or_path : String, params : Params = Params.new) : Response
        {{method.id}}(url_or_path, params) { }
      end


      def {{method.id}}(url_or_path : String, params : Params|Nil = nil) : Response
        uri = complete_uri!(URI.parse(url_or_path))

        if params
          query = HTTP::Params.build do |form|
            (params as Params).each { |name, val| form.add(name, val) }
          end

          if uri.query
            uri.query = [uri.query, query].join("&")
          else
            uri.query = query
          end
        end

        request = Request.new(:{{method.id}}, uri, @headers.clone)
        yield(request)
        env = Env.new(request)
        @app.call(env).response as Response
      end
    {% end %}


    {% for method in %w(post put patch) %}
      def {{method.id}}(url_or_path : String, body : String = "")
        {{method.id}}(url_or_path, body) { }
      end

      def {{method.id}}(url_or_path : String, body : String = "")
        uri = complete_uri!(URI.parse(url_or_path))
        request = Request.new(:{{method.id}}, uri, @headers.clone, body)
        yield(request)
        env = Env.new(request)
        @app.call(env).response as Response
      end
    {% end %}


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
