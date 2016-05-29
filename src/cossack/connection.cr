module Cossack
  class Middleware
    @app : HttpAdapter|Middleware

    def initialize
      @app = HttpAdapter.new
    end

    def app=(app : HttpAdapter|Middleware)
      @app = app
    end

    def app
      @app
    end

    def call(env : Env) : Env
      @app.call(env)
    end
  end

  class Connection
    @url : String?
    @app : HttpAdapter|Middleware

    def initialize(@url = nil)
      @middlewares = [] of Middleware
      @app = HttpAdapter.new
    end

    def finalize!
      @middlewares.reverse.each do |md|
        md.app = @app
        @app = md
      end
    end

    def add_middleware(md)
      @middlewares << md
    end

    def get(path : String, params : Hash(String, String) = {} of String => String) : Response
      url = path
      request = Request.new(:get, url, params)
      env = Env.new(request)
      @app.call(env).response as Response
    end
  end
end
