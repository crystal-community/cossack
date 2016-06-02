module Cossack
  # Is used only like a work around to initialize Middleware until it gets a real instance of @app.
  class NullAdapter < Adapter
    def self.instance
      @@instance ||= new
    end

    def call(env : Env) : Env
      env
    end
  end
end
