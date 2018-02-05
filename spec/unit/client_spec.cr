require "../spec_helper"

describe Cossack::Client do
  it "can be initialized" do
    Cossack::Client.new
  end

  it "has a basic_auth that works" do
    client = Cossack::Client.new(TEST_SERVER_URL) do |client|
      client.basic_auth("test", "secret")
    end
    client.headers["Authorization"].should_not be_nil
    client.headers["Authorization"].should eq("Basic dGVzdDpzZWNyZXQ=")
  end
end
