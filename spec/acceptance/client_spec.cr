require "../spec_helper"

describe Cossack::Client do
  describe "#get" do
    it "works with base url" do
      client = Cossack::Client.new("http://localhost:3999/math/")
      response = client.get("/add", {"a" => "2", "b" => "3"})
      response.body.should eq "5"
      response.status.should eq 200
      response.headers["Content-Length"].should eq "1"
    end

    it "works without base url" do
      client = Cossack::Client.new
      response = client.get("http://localhost:3999/math/add", {"a" => "1", "b" => "2"})
      response.body.should eq "3"
    end

    describe "sending headers" do
      it "sends User-Agent header by default" do
        client = Cossack::Client.new
        response = client.get("http://localhost:3999/http/header/User-Agent")
        response.body.should eq "Cossack v#{Cossack::VERSION}"
      end

      it "allows to add headers to individual request" do
        client = Cossack::Client.new
        response = client.get("http://localhost:3999/http/header/X-FOO") do |request|
          request.headers["X-FOO"] = "bar"
        end

        response.body.should eq "bar"
      end

      it "allows to add header to the client" do
        client = Cossack::Client.new("http://localhost:3999") do |client|
          client.headers["X-FOO"] = "bar"
        end
        response = client.get("/http/header/X-FOO")
        response.body.should eq "bar"
      end
    end
  end
end
