module Cossack
  abstract class Middleware
    abstract def call(request : Request) : Response

    @app : Middleware|Connection|Proc(Request, Response)

    getter :app

    def initialize(@app)
    end

    def __set_app__(app)
      @app = app
    end
  end
end
