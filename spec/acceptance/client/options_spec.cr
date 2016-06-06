require "../../spec_helper"

Spec2.describe "OPTIONS requests" do
  let(client) { Cossack::Client.new(TEST_SERVER_URL) }

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

  context "using module method" do
    it "sends OPTIONS" do
      response = Cossack.options("#{TEST_SERVER_URL}/http/reflect")
      expect(response.status).to eq 200
      expect(response.headers["REQUEST-METHOD"]).to eq "OPTIONS"
    end

    it "sends HEAD with custom headers" do
      response = Cossack.options("#{TEST_SERVER_URL}/http/reflect") do |request|
        request.headers["CUSTOM"] = "fun"
      end
      expect(response.headers["REQUEST-HEADER-CUSTOM"]).to eq "fun"
      expect(response.headers["REQUEST-METHOD"]).to eq "OPTIONS"
    end
  end
end
