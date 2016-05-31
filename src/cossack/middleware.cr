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
end
