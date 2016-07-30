require "http/cookie"
require "http/headers"

module Cossack
  class CookieJar < HTTP::Cookies
    def export_to_file(file_path : String)
      # exports to Set-Cookie header values
      headers = self.add_response_headers(HTTP::Headers.new)

      File.open(file_path, "w") do |file|
        headers.get("Set-Cookie").each { |line| file.puts line } unless headers.empty?
      end
    end

    def self.from_file(file_path : String)
      new.tap {|cj| cj.import_from_file(file_path) }
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
