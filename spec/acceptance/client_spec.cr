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
  end
end
