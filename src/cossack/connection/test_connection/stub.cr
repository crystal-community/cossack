module Cossack
  class TestConnection < Connection
    class Stub
      getter :request_matcher, :response

      def initialize(@request_matcher : RequestMatcher, @response : Response)
      end

      def matches?(request : Request)
        @request_matcher.matches?(request)
      end
    end
  end
end
