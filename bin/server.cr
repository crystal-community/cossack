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

{% for method in %w(get post put patch delete options) %}
  {{method.id}} "/http/reflect" do |env|
    env.response.headers["REQUEST-METHOD"] = env.request.method.to_s
    env.response.headers["REQUEST-BODY"] = env.request.body.to_s

    env.request.headers.each do |name, value|
      new_name = "REQUEST-HEADER-#{name}"
      env.response.headers[new_name] = value
    end

    env.request.body.to_s
  end
{% end %}

get "/delay/:delay" do |env|
  delay = env.params.url["delay"].to_f
  sleep delay
  delay.to_s
end

Kemal.run
