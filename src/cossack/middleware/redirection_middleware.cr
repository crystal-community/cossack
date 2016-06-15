module Cossack
  # Follows 3xx redirects.
  #
  # ```
  # Cossack::Client.new do |client|
  #   # follow up to 10 redirects (by default 5)
  #   client.use Cossack::RedirectionMiddleware, limit: 10
  # end
  # ```
  class RedirectionMiddleware < Middleware
    @limit : Int32

    def initialize(@app, limit : Number = 5)
      @limit = limit.to_i
    end

    def call(request : Request) : Response
      current_request = request
      count = 0
      response = app.call(request)

      while response.redirection? && response.headers["Location"]? && count < @limit
        count += 1
        redirect_uri = URI.parse(response.headers["Location"])
        merge_uri!(redirect_uri, current_request.uri)
        current_request = Request.new("GET", redirect_uri, current_request.headers, nil, current_request.options)
        response = app.call(current_request)
      end

      response
    end

    private def merge_uri!(redirect_uri, original_uri)
      # Unless it is absolute URL
      unless redirect_uri.host
        redirect_uri.host ||= original_uri.host
        redirect_uri.scheme ||= original_uri.scheme
        redirect_uri.port ||= original_uri.port
        redirect_uri.user ||= original_uri.user
        redirect_uri.password ||= original_uri.password

        # If path is relative
        unless redirect_uri.path.to_s.starts_with? '/'
          # Remove last part in path, e.g. "/users/13" => "/users/"
          base_path = original_uri.path.to_s.sub(%r{/[^/]+$}, "/")

          # TODO: implement `URI.join` method in Crystal
          redirect_uri.path = File.join(base_path, redirect_uri.path.to_s)
        end
      end
    end
  end
end
