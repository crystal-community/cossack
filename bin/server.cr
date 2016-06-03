require "kemal"

get "/" do
  "root"
end

get "/math/add" do |env|
  query = env.params.query
  a = query["a"]? ? query["a"].to_i : 0
  b = query["b"]? ? query["b"].to_i : 0
  a + b
end

get "/http/header/:header_name" do |env|
  header_name = env.params.url["header_name"].to_s
  env.request.headers[header_name]
end

post "/http/header/:header_name" do |env|
  header_name = env.params.url["header_name"].to_s
  env.request.headers[header_name]
end

post "/http/body" do |env|
  env.response.headers["X-METHOD"] = "POST"
  env.request.body
end

put "/http/reflect" do |env|
  env.response.headers["REQUEST-METHOD"] = "PUT"
  env.response.headers["REQUEST-BODY"] = env.request.body.to_s
  env.response.headers["REQUEST-HEADER-X-FOO"] = env.request.headers["X-FOO"]
  env.request.body.to_s
end

patch "/http/reflect" do |env|
  env.response.headers["REQUEST-METHOD"] = "PATCH"
  env.response.headers["REQUEST-BODY"] = env.request.body.to_s
  env.response.headers["REQUEST-HEADER-X-FOO"] = env.request.headers["X-FOO"]
  env.request.body.to_s
end



Kemal.run
