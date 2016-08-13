require "../cookie_jar"
require "./middleware"

module Cossack
  # Stores persistent set of cookies
  #
  # ```
  # cookies = CookieJar.new
  # Cossack::Client.new do |client|
  #   # store in cookie jar you provide
  #   client.use Cossack::CookieJarMiddleware, cookie_jar: cookies
  # end
  # ```
  #
  class CookieJarMiddleware < Middleware
    getter :cookie_jar

    def initialize(@app, @cookie_jar : CookieJar = CookieJar.new)
    end

    def call(request)
      cookie_jar.add_request_headers(request.headers)
      response = app.call(request)
      cookie_jar.fill_from_headers(response.headers)

      response
    end
  end
end
