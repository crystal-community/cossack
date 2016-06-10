require "../src/cossack"

class DurationLogger < Cossack::Middleware
  def call(request)
    start_time = Time.now

    response = @app.call(request)

    duration = (Time.now - start_time).to_f
    print "DurationLogger"
    puts " [#{duration}] #{request.uri.to_s}"

    response
  end
end

cossack = Cossack::Client.new do |client|
  client.add_middleware DurationLogger.new
end

response = cossack.get("http://jsonplaceholder.typicode.com/posts", {"postId" => "1"})
puts response.status
