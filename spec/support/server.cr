# Server for acceptance tests.

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

get "/redirect/:count" do |env|
  count = env.params.url["count"].to_i
  env.response.headers["COUNT"] = count.to_s
  case count % 3
  when 0 then env.redirect "/redirect/#{count + 1}"
  when 1 then env.redirect "#{count + 1}"
  when 2 then env.redirect "http://0.0.0.0:3999/redirect/#{count + 1}"
  end
end

get "/cookie" do |env|
  cookie = env.request.headers["Cookie"]?

  cookie ? "Cookie: #{cookie}" : "No cookie found"
end

put "/cookie" do |env|
  cookie = env.params.query["cookie"]?
  cookie ||= env.params.json["cookie"]?.as(String?)
  if cookie
    cookie.split(";").each do |line|
      next unless line.strip.size > 0
      env.response.headers.add "Set-Cookie", line.strip
    end
    "Cookie set"
  else
    "No cookie given"
  end
end

Kemal.run
