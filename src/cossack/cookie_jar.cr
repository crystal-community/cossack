require "http/cookie"
require "http/headers"

module Cossack
  # Stores cookies similar to HTTP::Cookies from Crystal's Std Library, but adds
  # persistence methods in order to import/export to a file. The format is in
  # Set-Cookie header style because Cookie headers lose information such as
  # domain, http_only, and path restrictions
  class CookieJar < HTTP::Cookies
    def self.from_file(file_path : String)
      new.tap {|cj| cj.import_from_file(file_path) }
    end

    def export_to_file(file_path : String)
      # exports to Set-Cookie header values
      headers = self.add_response_headers(HTTP::Headers.new)

      File.open(file_path, "w") do |file|
        headers.get("Set-Cookie").each { |line| file.puts line } unless headers.empty?
      end
    end

    def import_from_file(file_path : String)
      return self unless File.exists?(file_path)

      # imports from Set-Cookie header values
      tmp_headers = HTTP::Headers.new
      File.each_line(file_path) do |line|
        next unless line.strip.size == 0
        tmp_headers.add("Set-Cookie", line.strip)
      end

      fill_from_headers(tmp_headers) unless tmp_headers.empty?
    end

    # OVERRIDE

    # The methods below as they appear in the Std Library (as of v0.18.7) add a
    # header that is blank if the cookie jar is empty instead of not adding any
    # header at all.

    def add_request_headers(headers)
      super(headers) unless empty?

      headers
    end

    def add_response_headers(headers)
      super(headers) unless empty?

      headers
    end
  end
end
