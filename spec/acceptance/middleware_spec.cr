require "../spec_helper"

# Writes response to Array @responses.
class TestMiddlwareWriter < Cossack::Middleware
  def initialize(@responses = [] of String)
    super()
  end

  def call(env)
    app.call(env)
    @responses << (env.response as Cossack::Response).body
    env
  end
end

# Does nothing
class TestMiddlewareNull < Cossack::Middleware
  def call(env)
    app.call(env)
  end
end

describe "Middleware usage" do
  it "allows to register middleware" do
    responses = [] of String

    client = Cossack::Client.new("http://localhost:3999/") do |client|
      client.add_middleware TestMiddlwareWriter.new(responses)
      client.add_middleware TestMiddlewareNull.new
    end

    client.get("/")
    responses.should eq ["root"]

    client.get("/math/add", {"a" => "4", "b" => "5"})
    responses.should eq ["root", "9"]
  end
end
