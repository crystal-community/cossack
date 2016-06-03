require "../../spec_helper"

Spec2.describe "DELETE requests" do
  let(client) { Cossack::Client.new("http://localhost:3999") }

  describe "#delete" do
    it "sends DELETE request" do
      response = client.delete("/http/reflect")
      expect(response.headers["REQUEST-METHOD"]).to eq "DELETE"
    end

    it "sends DELETE request with header" do
      response = client.delete("/http/reflect") do |request|
        request.headers["X-FOO"] = "header value"
      end
      expect(response.headers["REQUEST-HEADER-X-FOO"]).to eq "header value"
    end
  end
end
