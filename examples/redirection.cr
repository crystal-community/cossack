require "../src/cossack"

cossack = Cossack::Client.new do |client|
  client.add_middleware Cossack::RedirectionMiddleware, limit: 13
end

cossack.get "http://google.com"
