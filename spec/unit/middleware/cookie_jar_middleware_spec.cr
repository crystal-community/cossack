require "../../spec_helper"

Spec2.describe Cossack::CookieJarMiddleware do
  let(connection) { Cossack::TestConnection.new }
  let(cookie_jar) { Cossack::CookieJar.new }
  let(middleware) { Cossack::CookieJarMiddleware.new(connection, cookie_jar) }
  let(check_request) { Cossack::Request.new("GET", "http://example.com/abc/check_cookies") }
  let(set_request) { Cossack::Request.new("GET", "http://example.com/abc/set_cookies") }

  let(cookie) { HTTP::Cookie.new("foo", "bar") }

  before do
    connection.stub_get("http://example.com/abc/check_cookies", {
      "Cookie" => cookie.to_cookie_header
    }, {
      200,
      "OK"
    })
    connection.stub_get("http://example.com/abc/check_cookies", {
      200,
      "Not OK"
    })
    connection.stub_get("http://example.com/abc/set_cookies", {
      200,
      {
        "Set-Cookie" => cookie.to_set_cookie_header
      },
      "OK"
    })
  end

  it "has a cookie jar" do
    expect(middleware.responds_to?(:cookie_jar)).to be_true
  end

  context "when cookie is in cookie jar" do
    it "sets cookie request header" do
      expect(middleware.call(check_request).body).to eq("Not OK")
      middleware.cookie_jar << cookie
      expect(middleware.call(check_request).body).to eq("OK")
    end
  end

  context "when receiving set-cookie headers" do
    it "sets the cookie in the cookie jar" do
      expect(middleware.cookie_jar.has_key?(cookie.name)).to be_false
      middleware.call(set_request)
      expect(middleware.cookie_jar.has_key?(cookie.name)).to be_true
      expect(middleware.cookie_jar[cookie.name].value).to eq(cookie.value)
    end
  end
end
