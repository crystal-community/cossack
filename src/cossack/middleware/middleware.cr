module Cossack
  abstract class Middleware
    abstract def call(request : Request) : Response

    @app : Middleware|Connection|Proc(Request, Response)

    getter :app

    def initialize(@app)
    end

    # Internal public method. Used in Client to swap a connection.
    def __set_app__(app)
      @app = app
    end
  end
end
