module Cossack
  class Request
    getter :method, :url, :params

    def initialize(@method : Symbol, @url : String, @params : Hash(String, String))
    end
  end
end
