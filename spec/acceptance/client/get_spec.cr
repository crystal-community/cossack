Spec2.describe "GET requests" do
  let(client) { Cossack::Client.new(TEST_SERVER_URL) }

  describe "#get" do
    it "sends GET request" do
      response = client.get("/http/reflect")
      expect(response.headers["REQUEST-METHOD"]).to eq "GET"
      expect(response.status).to eq 200
    end

    it "sends GET request with header" do
      response = client.get("/http/reflect") do |request|
        request.headers["X-FOO"] = "header value"
      end
      expect(response.headers["REQUEST-HEADER-X-FOO"]).to eq "header value"
    end
  end
end
