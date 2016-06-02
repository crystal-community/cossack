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

Kemal.run
