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
      cookies_to_send = CookieJar.new

      cookie_jar.each do |cookie|
        next if cookie.secure && request.uri.scheme != "https"
        next if cookie.domain && !request.uri.host.to_s.ends_with?(cookie.domain.as(String))
        next if cookie.path   && !request.uri.path.to_s.starts_with?(cookie.path.as(String))

        cookies_to_send << cookie
      end
      cookies_to_send.add_request_headers(request.headers)
      response = app.call(request)
      cookie_jar.fill_from_headers(response.headers)

      response
    end
  end
end
