require "../../spec_helper"

Spec2.describe Cossack::CookieJarMiddleware do
  let(connection) { Cossack::TestConnection.new }
  let(cookie_jar) { Cossack::CookieJar.new }
  let(middleware) { Cossack::CookieJarMiddleware.new(connection, cookie_jar) }
  let(check_request) { Cossack::Request.new("GET", "http://example.com/abc/check_cookies") }
  let(secure_check_request) { Cossack::Request.new("GET", "https://example.com/abc/check_cookies") }
  let(set_request) { Cossack::Request.new("GET", "http://example.com/abc/set_cookies") }

  let(cookie) { HTTP::Cookie.new("foo", "bar", domain: "example.com") }
  let(bad_domain_cookie) { HTTP::Cookie.new("fizz", "buzz", domain: "example.net") }
  let(no_domain_cookie) { HTTP::Cookie.new("lorem", "ipsum", domain: nil) }
  let(bad_path_cookie) { HTTP::Cookie.new("dolor", "sit", path: "/amet", domain: "example.com") }
  let(secure_cookie) { HTTP::Cookie.new("herp", "derp", domain: "example.com", secure: true) }

  before do
    connection.stub_get("http://example.com/abc/check_cookies", {
      "Cookie" => cookie.to_cookie_header
    }, {
      200,
      "Correct Cookies"
    })
    connection.stub_get("http://example.com/abc/check_cookies", {
      "Cookie" => no_domain_cookie.to_cookie_header
    }, {
      200,
      "Correct Cookies"
    })
    connection.stub_get("http://example.com/abc/check_cookies", {
      "Cookie" => bad_domain_cookie.to_cookie_header
    }, {
      200,
      "Incorrect Cookie Domain"
    })
    connection.stub_get("http://example.com/abc/check_cookies", {
      "Cookie" => bad_path_cookie.to_cookie_header
    }, {
      200,
      "Incorrect Cookie Path"
    })
    connection.stub_get("http://example.com/abc/check_cookies", {
      "Cookie" => secure_cookie.to_cookie_header
    }, {
      200,
      "Incorrectly sent https-only cookie"
    })
    connection.stub_get("https://example.com/abc/check_cookies", {
      "Cookie" => secure_cookie.to_cookie_header
    }, {
      200,
      "Correct Cookies"
    })
    connection.stub_get("http://example.com/abc/check_cookies", {
      200,
      "No Cookies"
    })
    connection.stub_get("https://example.com/abc/check_cookies", {
      200,
      "No Cookies"
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
      expect(middleware.call(check_request).body).to eq("No Cookies")
      middleware.cookie_jar << cookie
      expect(middleware.call(check_request).body).to eq("Correct Cookies")
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

  it "filters only applicable cookies for outbound request domain" do
    expect(middleware.call(check_request).body).to eq("No Cookies")
    middleware.cookie_jar << bad_domain_cookie
    expect(middleware.call(check_request).body).to eq("No Cookies")
  end

  context "when cookies do not have a domain set" do
    it "sends the cookie regardless of the domain" do
      expect(middleware.call(check_request).body).to eq("No Cookies")
      middleware.cookie_jar << no_domain_cookie
      expect(middleware.call(check_request).body).to eq("Correct Cookies")
    end
  end

  it "filters only applicable cookies for outbound request path" do
    expect(middleware.call(check_request).body).to eq("No Cookies")
    middleware.cookie_jar << bad_path_cookie
    expect(middleware.call(check_request).body).to eq("No Cookies")
  end

  it "filters only applicable cookies for https requests" do
    expect(middleware.call(check_request).body).to eq("No Cookies")
    expect(middleware.call(secure_check_request).body).to eq("No Cookies")
    middleware.cookie_jar << secure_cookie
    expect(middleware.call(check_request).body).to eq("No Cookies")
    expect(middleware.call(secure_check_request).body).to eq("Correct Cookies")
  end
end
