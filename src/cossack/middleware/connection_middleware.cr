require "./middleware"

module Cossack
  class ConnectionMiddleware < Middleware
    def initialize(@connection : Connection)
      super()
    end

    def call(env : Env) : Env
      request = env.request
      response = @connection.call(request)
      env.response = response
      env
    end
  end
end
