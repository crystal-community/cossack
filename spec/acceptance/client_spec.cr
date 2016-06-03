require "../spec_helper"

Spec2.describe Cossack::Client do
  describe "#get" do
    it "works with base url" do
      client = Cossack::Client.new("http://localhost:3999/math/")
      response = client.get("/add", {"a" => "2", "b" => "3"})
      expect(response.body).to eq "5"
      expect(response.status).to eq 200
      expect(response.headers["Content-Length"]).to eq "1"
    end

    it "works without base url" do
      client = Cossack::Client.new
      response = client.get("http://localhost:3999/math/add", {"a" => "1", "b" => "2"})
      expect(response.body).to eq "3"
    end

    describe "sending headers" do
      let(client) { Cossack::Client.new("http://localhost:3999") }

      it "sends User-Agent header by default" do
        response = client.get("/http/header/User-Agent")
        expect(response.body).to eq "Cossack v#{Cossack::VERSION}"
      end

      it "allows to add headers to individual request" do
        response = client.get("/http/header/X-FOO") do |request|
          request.headers["X-FOO"] = "bar"
        end
        expect(response.body).to eq "bar"
      end

      it "allows to add header to the client" do
        client = Cossack::Client.new("http://localhost:3999") do |client|
          client.headers["X-FOO"] = "bar"
        end
        response = client.get("/http/header/X-FOO")
        expect(response.body).to eq "bar"
      end
    end
  end

  describe "#post" do
    let(client) { Cossack::Client.new("http://localhost:3999") }

    it "sends POST request with body " do
      response = client.post("/http/body", "BODY CONTENT")
      expect(response.body).to eq "BODY CONTENT"
    end

    it "can send POST request without body" do
      response = client.post("/http/body")
      expect(response.body).to eq ""
    end

    it "allows to specify headers for individual request" do
      response = client.post("/http/header/X-HEADER") do |request|
        request.headers["X-HEADER"] = "the value"
      end
      expect(response.body).to eq "the value"
    end
  end

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

  describe "#patch" do
    let(client) { Cossack::Client.new("http://localhost:3999") }

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
