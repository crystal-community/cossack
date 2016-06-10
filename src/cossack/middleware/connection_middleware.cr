require "./middleware"

module Cossack
  class ConnectionMiddleware < Middleware
    @connection : Connection|Proc(Request, Response)

    property :connection

    def initialize(@connection : Connection)
      super()
    end

    def call(request) : Response
      @connection.call(request)
    end
  end
end
