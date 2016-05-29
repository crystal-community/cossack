require "../src/cossack"

cossack = Cossack.new

class DurationLogger < Cossack::Middleware
  def call(env : Cossack::Env) : Cossack::Env
    start_time = Time.now

    @app.call(env)

    duration = (Time.now - start_time)

    puts "#{env.request.url}   #{duration}"

    env
  end
end

cossack.add_middleware(Cossack::Middleware.new)
cossack.add_middleware(DurationLogger.new)
cossack.finalize!

response = cossack.get("http://jsonplaceholder.typicode.com/posts", {"postId" => "1"})


pp response.status
#puts
#pp response.headers
#puts
#puts response.body[0..200]
