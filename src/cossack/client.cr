module Cossack
  class Client
    #@url : String?
    @app : HttpAdapter|Middleware

    def initialize
      @middlewares = [] of Middleware
      @app = HttpAdapter.new
    end

    def initialize
      initialize
      yield self
    end


    def add_middleware(md : Middleware)
      md.app = @app
      @app = md
    end

    def get(path : String, params : Hash(String, String) = {} of String => String) : Response
      url = path
      request = Request.new(:get, url, params)
      env = Env.new(request)
      @app.call(env).response as Response
    end
  end
end
