require "../../spec_helper"

Spec2.describe "HEAD requests" do
  let(client) { Cossack::Client.new("http://localhost:3999") }

  describe "#head" do
    it "sends HEAD request" do
      response = client.head("/http/reflect")
      expect(response.headers["REQUEST-METHOD"]).to eq "HEAD"
      expect(response.status).to eq 200
      expect(response.body).to eq ""
    end

    it "sends HEAD request with header" do
      response = client.head("/http/reflect") do |request|
        request.headers["X-FOO"] = "header value"
      end
      expect(response.headers["REQUEST-HEADER-X-FOO"]).to eq "header value"
    end
  end
end
