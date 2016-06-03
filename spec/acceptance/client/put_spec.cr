require "../../spec_helper"

Spec2.describe "PUT requests" do
  let(client) { Cossack::Client.new(TEST_SERVER_URL) }

  describe "#put" do
    let(client) { Cossack::Client.new("http://localhost:3999") }

    it "sends PUT request" do
      response = client.put("/http/reflect", "korpo")
      expect(response.headers["REQUEST-METHOD"]).to eq "PUT"
      expect(response.headers["REQUEST-BODY"]).to eq "korpo"
    end

    it "sends PUT request without body" do
      response = client.put("/http/reflect")
      expect(response.headers["REQUEST-METHOD"]).to eq "PUT"
    end

    it "sends PUT request with header" do
      response = client.put("/http/reflect") do |request|
        request.headers["X-FOO"] = "header value"
      end
      expect(response.headers["REQUEST-HEADER-X-FOO"]).to eq "header value"
    end
  end
end
