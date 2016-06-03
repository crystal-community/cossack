require "../spec_helper"

Spec2.describe "Client" do
  it "works with base url" do
    client = Cossack::Client.new("#{TEST_SERVER_URL}/math/")
    response = client.get("/add", {"a" => "2", "b" => "3"})
    expect(response.body).to eq "5"
    expect(response.status).to eq 200
    expect(response.headers["Content-Length"]).to eq "1"
  end

  it "works without base url" do
    client = Cossack::Client.new
    response = client.get("#{TEST_SERVER_URL}/math/add", {"a" => "1", "b" => "2"})
    expect(response.body).to eq "3"
  end

  it "sends User-Agent header by default" do
    client =  Cossack::Client.new(TEST_SERVER_URL)
    response = client.get("/http/reflect")
    expect(response.headers["REQUEST-HEADER-User-Agent"]?).to eq "Cossack v#{Cossack::VERSION}"
  end

  it "allows to add header to the client" do
    client = Cossack::Client.new(TEST_SERVER_URL) do |client|
      client.headers["X-FOO"] = "bar"
    end

    response = client.get("/http/reflect")
    expect(response.headers["REQUEST-HEADER-X-FOO"]?).to eq "bar"

    response = client.post("/http/reflect")
    expect(response.headers["REQUEST-HEADER-X-FOO"]?).to eq "bar"
  end
end
