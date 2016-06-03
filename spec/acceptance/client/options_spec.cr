require "../../spec_helper"

Spec2.describe "OPTIONS requests" do
  let(client) { Cossack::Client.new("http://localhost:3999") }

  describe "#options" do
    it "sends OPTIONS request" do
      response = client.options("/http/reflect")
      expect(response.headers["REQUEST-METHOD"]).to eq "OPTIONS"
      expect(response.status).to eq 200
    end

    it "sends OPTIONS request with header" do
      response = client.options("/http/reflect") do |request|
        request.headers["X-FOO"] = "header value"
      end
      expect(response.headers["REQUEST-HEADER-X-FOO"]).to eq "header value"
    end
  end
end
