require "../spec_helper"

describe Cossack::Client do
  describe "#get" do
    it "works with base url" do
      client = Cossack::Client.new("http://localhost:3999")
      response = client.get("/math/add", {"a" => "2", "b" => "3"})
      response.body.should eq "5"
    end

    it "works without base url" do
    end
  end
end
