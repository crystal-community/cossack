require "../spec_helper"

Spec2.describe "CookieJarMiddleware usage" do
  let(client) do
    client = Cossack::Client.new(TEST_SERVER_URL)
    client.use Cossack::CookieJarMiddleware, cookie_jar: client.cookies
    client
  end

  it "allows to register middleware" do
    expect { client }.not_to raise_error
  end

  it "persists cookies between requests" do
    expect(client.get("/cookie").body).to eq("No cookie found")
    expect(client.cookies.empty?).to be_true

    response = client.put("/cookie", "{ \"cookie\": \"test_cookie=works\" }") do |request|
      request.headers["Content-Type"] = "application/json"
    end
    expect(response.headers["Set-Cookie"]?).not_to be_nil
    expect(client.cookies.empty?).to be_false

    expect(client.get("/cookie").body).to match(/^Cookie: (?:.+;)?test_cookie=works(?:;.+|$)/)
  end

  it "handles cookies added manually" do
    expect(client.get("/cookie").body).to eq("No cookie found")
    expect(client.cookies.empty?).to be_true

    client.cookies << HTTP::Cookie.new("some_cookie", "some_value")

    expect(client.cookies.empty?).to be_false
    expect(client.get("/cookie").body).to match(/^Cookie: (?:.+;)?some_cookie=some_value(?:;.+|$)/)
  end
end
