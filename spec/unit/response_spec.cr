require "../spec_helper"

Spec2.describe Cossack::Response do
  describe "#initialize" do
    it "initializes with all arguments" do
      headers = HTTP::Headers.new
      headers["Content-Length"] = "4"
      response = Cossack::Response.new(204, headers, "Bang")

      expect(response.status).to eq 204
      expect(response.headers.class).to eq HTTP::Headers
      expect(response.headers["Content-Length"]).to eq "4"
      expect(response.body).to eq "Bang"
    end

    it "initializes with Hash(String, String) as a header" do
      response = Cossack::Response.new(204, {"Content-Length" => "4"}, "Bang")

      expect(response.status).to eq 204
      expect(response.headers.class).to eq HTTP::Headers
      expect(response.headers["Content-Length"]).to eq "4"
      expect(response.body).to eq "Bang"
    end

    it "initializes without headers" do
      response = Cossack::Response.new(204, "Bang")

      expect(response.status).to eq 204
      expect(response.headers.class).to eq HTTP::Headers
      expect(response.body).to eq "Bang"
    end
  end

  describe "#success?" do
    it "returns true for status between 200 and 299" do
      { 199 => false,
        200 => true,
        204 => true,
        299 => true,
        300 => false
      }.each do |status, expected_value|
        response = Cossack::Response.new(status, "")
        expect(response.success?).to eq expected_value
      end
    end
  end
end
