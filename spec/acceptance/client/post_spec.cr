require "../../spec_helper"

Spec2.describe "POST requests" do
  let(client) { Cossack::Client.new(TEST_SERVER_URL) }

  describe "#post" do
    it "sends POST request with body " do
      response = client.post("/http/reflect", "BODY CONTENT")
      expect(response.body).to eq "BODY CONTENT"
    end

    it "can send POST request without body" do
      response = client.post("/http/reflect")
      expect(response.body).to eq ""
    end

    it "allows to specify headers for individual request" do
      response = client.post("/http/reflect") do |request|
        request.headers["X-FOO"] = "header value"
      end
      expect(response.headers["REQUEST-HEADER-X-FOO"]).to eq "header value"
    end
  end

  describe "using module method" do
    it "sends POST" do
      response = Cossack.post("#{TEST_SERVER_URL}/http/reflect", "amo")
      expect(response.status).to eq 200
      expect(response.body).to eq "amo"
    end

    it "sends POST with custom headers" do
      response = Cossack.post("#{TEST_SERVER_URL}/http/reflect", "amo") do |request|
        request.headers["CUSTOM"] = "fun"
      end
      expect(response.status).to eq 200
      expect(response.body).to eq "amo"
      expect(response.headers["REQUEST-HEADER-CUSTOM"]).to eq "fun"
    end
  end
end
