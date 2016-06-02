module Cossack
  class Middleware
    @app : Adapter|Middleware

    def initialize
      @app = NullAdapter.instance
    end

    def app=(app : Adapter|Middleware)
      if @app.is_a?(NullAdapter)
        @app = app
      else
        raise Error.new("Use one instance of middleware per Cossack::Client. " \
                        "Middleware #{self.inspect} is already in use.")
      end
    end

    def app
      @app
    end

    def call(env : Env) : Env
      @app.call(env)
    end
  end
end
