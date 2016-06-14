require "../spec_helper"

Spec2.describe "Client with RedirectionMiddleware" do
  it "follows default number of redirections" do
    client = Cossack::Client.new(TEST_SERVER_URL) do |client|
      client.use Cossack::RedirectionMiddleware
    end

    response = client.get("/redirect/0")
    expect(response.headers["COUNT"]).to eq "5"
  end

  context "when redirection_limit is specified" do
    it "follows specified number of redirections" do
      client = Cossack::Client.new(TEST_SERVER_URL) do |client|
        client.use Cossack::RedirectionMiddleware, limit: 13
      end

      response = client.get("/redirect/0")
      expect(response.headers["COUNT"]).to eq "13"
    end
  end
end
