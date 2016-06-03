require "../../spec_helper"

Spec2.describe "PATCH requests" do
  let(client) { Cossack::Client.new(TEST_SERVER_URL) }

  describe "#patch" do
    it "sends PATCH request" do
      response = client.patch("/http/reflect", "korpo")
      expect(response.headers["REQUEST-METHOD"]).to eq "PATCH"
      expect(response.headers["REQUEST-BODY"]).to eq "korpo"
    end

    it "sends PATCH request without body" do
      response = client.patch("/http/reflect")
      expect(response.headers["REQUEST-METHOD"]).to eq "PATCH"
    end

    it "sends PATCH request with header" do
      response = client.patch("/http/reflect") do |request|
        request.headers["X-FOO"] = "header value"
      end
      expect(response.headers["REQUEST-HEADER-X-FOO"]).to eq "header value"
    end
  end
end
