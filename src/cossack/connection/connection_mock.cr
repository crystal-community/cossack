module Cossack
  class ConnectionMock < Connection
    def initialize
      @stubs = [] of Stub
    end

    def call(request : Request) : Response
      @stubs.each do |stub|
        return stub.response if stub.matches?(request)
      end

      error_message = <<-MESSAGE
      Request `#{request.method} #{request.uri.to_s}` is not stubbed.
      You can stub it with the following code:\n
          connection_mock.#{request.method.downcase}("#{request.uri.path}", {200, "Response body"})
        OR
          connection_mock.#{request.method.downcase}("#{request.uri}", {200, {"Response-Header" => "value"}, "Response body"})
        OR
          connection_mock.#{request.method.downcase}("#{request.uri}", {"Request-Header" => "value"}, {200, "Response body"})\n
      Where `connection_mock` is an instance of Cossack::ConnectionMock.\n
      MESSAGE
      raise(Cossack::MockError.new(error_message))
    end


    {% for method in %w(post put patch get delete head options) %}
      def {{method.id}}(url : String, response : {Int32, String})
        matcher = RequestMatcher.new("{{method.id.upcase}}", url)
        resp = Response.new(status: response[0], body: response[1])
        @stubs << Stub.new(matcher, resp)
      end

      def {{method.id}}(url : String, response : {Int32, Hash(String, String), String})
        matcher = RequestMatcher.new("{{method.id.upcase}}", url)
        resp = Response.new(status: response[0], headers: response[1], body: response[2])
        @stubs << Stub.new(matcher, resp)
      end

      def {{method.id}}(url : String, headers : Hash(String, String), response : {Int32, String})
        matcher = RequestMatcher.new("{{method.id.upcase}}", url, headers)
        resp = Response.new(status: response[0], body: response[1])
        @stubs << Stub.new(matcher, resp)
      end

      def {{method.id}}(url : String, headers : Hash(String, String), response : {Int32, Hash(String, String), String})
        matcher = RequestMatcher.new("{{method.id.upcase}}", url, headers)
        resp = Response.new(status: response[0], headers: response[1], body: response[2])
        @stubs << Stub.new(matcher, resp)
      end
    {% end %}

    {% for method in %w(post put patch) %}
      def {{method.id}}(url : String, body : String, response : {Int32, String})
        matcher = RequestMatcher.new("{{method.id.upcase}}", url, body: body)
        resp = Response.new(status: response[0], body: response[1])
        @stubs << Stub.new(matcher, resp)
      end

      def {{method.id}}(url : String, headers : Hash(String, String), body : String, response : {Int32, String})
        matcher = RequestMatcher.new("{{method.id.upcase}}", url, headers: headers, body: body)
        resp = Response.new(status: response[0], body: response[1])
        @stubs << Stub.new(matcher, resp)
      end

      def {{method.id}}(url : String, body : String, response : {Int32, Hash(String, String), String})
        matcher = RequestMatcher.new("{{method.id.upcase}}", url, body: body)
        resp = Response.new(status: response[0], headers: response[1], body: response[2])
        @stubs << Stub.new(matcher, resp)
      end

      def {{method.id}}(url : String, headers : Hash(String, String), body : String, response : {Int32, Hash(String, String), String})
        matcher = RequestMatcher.new("{{method.id.upcase}}", url, headers: headers, body: body)
        resp = Response.new(status: response[0], headers: response[1], body: response[2])
        @stubs << Stub.new(matcher, resp)
      end
    {% end %}
  end
end
