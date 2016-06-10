module Cossack
  # Is used only like a work around to initialize Middleware until it gets a real instance of @app.
  class NullMiddleware
    def call(request : Request) : Response
      Response.null_response
    end
  end
end
