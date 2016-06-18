require "../spec_helper"

# Writes response to Array @responses.
class TestMiddlwareWriter < Cossack::Middleware
  def initialize(@app, @responses = [] of String)
  end

  def call(request)
    app.call(request).tap do |response|
      @responses << response.body
    end
  end
end

# Does nothing
class TestMiddlewareNull < Cossack::Middleware
  def call(request)
    app.call(request)
  end
end

describe "Middleware usage" do
  it "allows to register middleware" do
    responses = [] of String

    client = Cossack::Client.new(TEST_SERVER_URL) do |client|
      client.use TestMiddlwareWriter, responses
      client.use TestMiddlewareNull
    end

    client.get("/")
    responses.should eq ["root"]

    client.get("/math/add", {"a" => "4", "b" => "5"})
    responses.should eq ["root", "9"]
  end

  it "works with swapped connection" do
    responses = [] of String

    client = Cossack::Client.new(TEST_SERVER_URL) do |client|
      client.use TestMiddlwareWriter, responses
      client.connection = -> (req : Cossack::Request) do
        Cossack::Response.new(201, HTTP::Headers.new, "hello")
      end
      client.get("/")
      responses.should eq ["hello"]
    end
  end

  it "works with swapped connection passed as proc" do
    responses = [] of String

    client = Cossack::Client.new(TEST_SERVER_URL) do |client|
      client.use TestMiddlwareWriter, responses
      client.connection = -> (req : Cossack::Request) do
        Cossack::Response.new(201, HTTP::Headers.new, "hello")
      end
      client.get("/")
      responses.should eq ["hello"]
    end
  end
end
