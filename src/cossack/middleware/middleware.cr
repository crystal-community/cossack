module Cossack
  abstract class Middleware
    @app : Middleware|NullMiddleware

    property :app

    def initialize
      @app = NullMiddleware.new
    end

    abstract def call(env : Env) : Env
  end
end
