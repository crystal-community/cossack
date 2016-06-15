require "../../spec_helper"

Spec2.describe Cossack::RedirectionMiddleware do
  let(connection) { Cossack::TestConnection.new }
  let(middleware) { Cossack::RedirectionMiddleware.new(connection) }
  let(request) { Cossack::Request.new("GET", "http://test.org/abc/origin") }

  let(location) { "new/target" }

  before do
    connection.stub_get("http://test.org/abc/origin", {302, {"Location" => location}, ""})
    connection.stub_get("http://test.org/abc/new/target", {200, "OK"})
  end

  context "when Location is relative path" do
    let(location) { "new/target" }

    it "follows redirect" do
      response = middleware.call(request)
      expect(response.body).to eq "OK"
    end
  end

  context "when Location is absolute path" do
    let(location) { "/abc/new/target" }

    it "follows redirect" do
      response = middleware.call(request)
      expect(response.body).to eq "OK"
    end
  end

  context "when Location is full URL" do
    let(location) { "http://test.org/abc/new/target" }

    it "follows redirect" do
      response = middleware.call(request)
      expect(response.body).to eq "OK"
    end
  end
end
