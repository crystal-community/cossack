module Cossack
  # A connection to perform a real HTTP request using the standard library.
  class HTTPConnection < Connection
    def call(request : Request) : Response
      uri = request.uri
      scheme = uri.scheme
      uri_host = uri.host
      client = if uri_host.nil?
        HTTP::Client.new(uri)
      else
        HTTP::Client.new(uri_host, uri.port, scheme == "https")
      end

      client.connect_timeout = request.options.connect_timeout
      client.read_timeout = request.options.read_timeout

      uri_string = uri.to_s
      base_url = uri.port.nil? ? "#{scheme}://#{uri_host}" : "#{scheme}://#{uri_host}:#{uri.port}"
      path = uri_string.starts_with?(base_url) ? uri_string[base_url.size, uri_string.size - base_url.size] : uri_string
      http_response = client.exec(request.method, path, request.headers, request.body)
      Response.new(http_response.status_code, http_response.headers, http_response.body)
    rescue err : IO::Timeout
      raise TimeoutError.new(err.message, cause: err)
    end
  end
end
