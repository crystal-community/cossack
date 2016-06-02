module Cossack
  class Request
    getter :method, :url, :params

    alias Params = Hash(String, String)

    def initialize(@method : Symbol, @url : String, @params : Params)
    end
  end
end
