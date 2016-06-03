module Cossack
  class Env
    @request : Request
    @response : Response

    property :request, :response

    def initialize(@request : Request, @response : Response = Response.null_response)
    end
  end
end
