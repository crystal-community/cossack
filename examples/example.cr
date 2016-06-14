require "../src/cossack"

require "colorize"

class DurationLogger < Cossack::Middleware
  def call(request)
    start_time = Time.now

    response = @app.call(request)

    duration = (Time.now - start_time).to_f
    print "DurationLogger".colorize.green
    puts " [#{duration.colorize.blue}] #{request.uri.to_s}"

    response
  end
end

class Cache < Cossack::Middleware
  def initialize
    super
    @cache = {} of String => Cossack::Response
  end

  def call(request)
    url = request.uri.to_s
    if @cache[url]?
      @cache[url]
    else
      @app.call(request).tap do |response|
        @cache[url] = response
      end
    end
  end
end

cossack = Cossack::Client.new do |client|
  client.use DurationLogger.new
  client.use Cache.new
end


2.times do
  response = cossack.get("http://jsonplaceholder.typicode.com/posts", {"postId" => "1"})
  #pp response.status
  #puts response.body[0..100].gsub("\n", " ").gsub(/\s+/, " ")
  #puts
end


start = Time.new

10.times do
  cossack.get("http://jsonplaceholder.typicode.com/posts", {"postId" => "1"})
end

puts Time.new - start
