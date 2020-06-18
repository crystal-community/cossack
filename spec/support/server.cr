# Server for acceptance tests.

require "kemal"

module Kemal
  class RouteHandler
    # Override Kemal RouteHandler to NOT add a HEAD route for a GET route
    def add_route(method : String, path : String, &handler : HTTP::Server::Context -> _)
      puts "add_route(#{method}, #{path})"
      add_to_radix_tree method, path, Route.new(method, path, &handler)
    end
  end
end

get "/" do
  "root"
end

get "/math/add" do |env|
  query = env.params.query
  a = query["a"]? ? query["a"].to_i : 0
  b = query["b"]? ? query["b"].to_i : 0
  (a + b).to_s
end

REFLECT_HANDLER = ->(env : HTTP::Server::Context) do
  env.response.headers["REQUEST-METHOD"] = env.request.method.to_s
  request_body = env.request.body
  body_string = if request_body.nil?
                  ""
                else
                  sb = String::Builder.new
                  IO.copy(request_body, sb)
                  sb.to_s
                end
  env.response.headers["REQUEST-BODY"] = body_string

  env.request.headers.each do |name, value|
    new_name = "REQUEST-HEADER-#{name}"
    env.response.headers[new_name] = value
  end

  body_string
end

{% for method in %w(get post put patch delete options) %}
  {{method.id}} "/http/reflect", &REFLECT_HANDLER
{% end %}

Kemal::RouteHandler::INSTANCE.add_route("HEAD", "/http/reflect", &REFLECT_HANDLER)

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
