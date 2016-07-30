require "../cookie_jar"
require "./middleware"

module Cossack
  class CookieJarMiddleware < Middleware
    def call(request)
      cookie_jar.add_request_headers(request.headers)
      response = app.call(request)
      cookie_jar.fill_from_headers(response.headers)

      response
    end

    def cookie_jar
      @cookie_jar ||= CookieJar.new
    end
  end
end
