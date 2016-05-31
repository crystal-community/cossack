require "../src/cossack"

require "colorize"

class DurationLogger < Cossack::Middleware
  def call(env : Cossack::Env) : Cossack::Env
    start_time = Time.now

    @app.call(env)

    duration = (Time.now - start_time).to_f
    print "DurationLogger".colorize.green
    puts " [#{duration.colorize.blue}] #{env.request.url}"

    env
  end
end

class Cache < Cossack::Middleware
  def initialize
    super
    @cache = {} of String => Cossack::Response
  end

  def call(env)
    url = env.request.url
    if @cache[url]?
      env.response = @cache[url]
    else
      @app.call(env)
      @cache[url] = env.response as Cossack::Response
    end

    env
  end
end

cossack = Cossack::Client.new do |client|
  client.add_middleware Cache.new
  client.add_middleware DurationLogger.new
end


3.times do
  response = cossack.get("http://jsonplaceholder.typicode.com/posts", {"postId" => "1"})
  pp response.status
  puts response.body[0..100].gsub("\n", " ").gsub(/\s+/, " ")
  puts
end
