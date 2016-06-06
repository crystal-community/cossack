require "./middleware"

module Cossack
  class ConnectionMiddleware < Middleware
    @connection : Connection|Proc(Request, Response)

    property :connection

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
