module Cossack
  class Client
    USER_AGENT = "Cossack v#{VERSION}"

    @base_uri : URI
    @headers : HTTP::Headers
    @cookies : CookieJar
    @app : Middleware|Connection|Proc(Request, Response)

    getter :base_uri, :headers, :request_options, :connection, :cookies

    def initialize(base_url = nil)
      @headers = default_headers
      @cookies = CookieJar.new
      @request_options = RequestOptions.new
      @connection = HTTPConnection.new
      @app = @connection
      @base_uri = base_url ? URI.parse(base_url) : URI.new
      @middlewares = [] of Middleware

      yield self
    end

    # When block is not given.
    def initialize(base_url = nil)
      initialize(base_url) { }
    end

    def use(middleware_class, *args, **nargs)
      @middlewares << middleware_class.new(@app, *args, **nargs)
      @app = @middlewares.last
    end

    def connection=(conn : Proc(Request, Response)|Connection)
      @connection = conn
      if @middlewares.first?
        @middlewares.first.__set_app__(@connection)
      else
        @app = @connection
      end
    end

    def call(request : Request) : Response
      @app.call(request)
    end

    {% for method in %w(get delete head options) %}
      def {{method.id}}(url : String, params : Params? = nil) : Response
        {{method.id}}(url, params) { }
      end

      def {{method.id}}(url : String, params : Params? = nil) : Response
        uri = complete_uri!(URI.parse(url))

        if params
          query = HTTP::Params.build do |form|
            (params.as(Params)).each { |name, val| form.add(name, val) }
          end
          if uri.query
            uri.query = [uri.query, query].join("&")
          else
            uri.query = query
          end
        end

        request = Request.new("{{method.id.upcase}}", uri, @headers.dup, options: @request_options.dup)
        yield(request)
        call(request)
      end
    {% end %}


    {% for method in %w(post put patch) %}
      def {{method.id}}(url : String, body : String = "")
        {{method.id}}(url, body) { }
      end

      def {{method.id}}(url : String, body : String = "")
        uri = complete_uri!(URI.parse(url))
        request = Request.new("{{method.id.upcase}}", uri, @headers.dup, body, @request_options.dup)
        yield(request)
        call(request)
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
