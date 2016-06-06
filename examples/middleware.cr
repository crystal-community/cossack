require "../src/cossack"

class DurationLogger < Cossack::Middleware
  def call(env : Cossack::Env) : Cossack::Env
    start_time = Time.now

    @app.call(env)

    duration = (Time.now - start_time).to_f
    print "DurationLogger"
    puts " [#{duration}] #{env.request.uri.to_s}"

    env
  end
end

cossack = Cossack::Client.new do |client|
  client.add_middleware DurationLogger.new
end

response = cossack.get("http://jsonplaceholder.typicode.com/posts", {"postId" => "1"})
puts response.status
