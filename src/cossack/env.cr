module Cossack
  class Env
    @request : Request
    @response : Response?

    property :request, :response

    def initialize(@request : Request)
    end
  end
end
