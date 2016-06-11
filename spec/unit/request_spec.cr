require "../spec_helper"

Spec2.describe Cossack::Request do
  describe "#initialize" do
    it "initializes a request" do
      request = Cossack::Request.new("GET", URI.parse("http://localhost"), HTTP::Headers.new, "body")
      expect(request.method).to eq "GET"
      expect(request.uri).to be_a URI
      expect(request.uri.to_s).to eq "http://localhost"
      expect(request.headers).to be_a HTTP::Headers
      expect(request.body).to eq "body"
    end
  end

  describe "#options" do
    let(request) { Cossack::Request.new("GET", URI.parse("http://localhost"), HTTP::Headers.new, "body") }

    it "is instance of RequestOptions" do
      expect(request.options).to be_a Cossack::RequestOptions
    end
  end
end
