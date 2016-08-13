# Cossack <img src="https://cloud.githubusercontent.com/assets/113512/15764341/65d90c06-292a-11e6-8f91-44ed93e024f8.png" alt="crystal Cossack logo" width="48">

[![Build Status](https://travis-ci.org/greyblake/crystal-cossack.svg?branch=master)](https://travis-ci.org/greyblake/crystal-cossack)
[![docrystal.org](http://docrystal.org/badge.svg?style=round)](http://docrystal.org/github.com/greyblake/crystal-cossack)

Simple and flexible HTTP client for Crystal with middleware and test support.

* [Installation](#installation)
* [Usage](#usage)
* [The concept](#the-concept)
* [Using Middleware](#using-middleware)
* [Connection swapping](#connection-swapping)
* [Testing](#testing)
* [FAQ](#faq)
  * [How to follow redirections](#how-to-follow-redirections)
  * [How to persist cookies between requests](#how-to-persist-cookies-between-requests)
  * [How to persist cookies past the life of the application](#how-to-persist-cookies-past-the-life-of-the-application)
* [Development](#development)
* [Roadmap](#roadmap)
* [Afterword](#afterword)
* [Contributors](#contributors)

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  cossack:
    github: greyblake/crystal-cossack
    version: ~> 0.1
```

And install dependencies:

```
crystal deps
```

## Usage

```crystal
require "cossack"

# Send a single GET request
response = Cossack.get("https://www.w3.org/")
response.body  # => "Bla bla bla"

# Create an instance of a client with basic URL
cossack = Cossack::Client.new("http://example.org") do |client|
  # Set headers
  client.headers["Authorization"] = "Bearer SECRET-TOKEN"

  # Modify request options (by default connect_timeout is 30 sec)
  client.request_options.connect_timeout = 60.seconds
end

# Send GET request to http://example.org/info
response = cossack.get("/info") do |request|
  # modify a particular request
  request.headers["Accept-Language"] = "eo"
end

# Explore response
response.status                     # => 200
response.body                       # => "Info"
response.headers["Content-Length"]  # => 4

# Send POST request
cossack.post("/comments", "Request body")
```

## The concept

Cossack is inspired by [Faraday](https://github.com/lostisland/faraday) and [Hurley](https://github.com/lostisland/hurley) libraries from the ruby world.

The main things are: Client, Request, Response, Connection, Middleware.
* **Client** - provides a convenient API to build and perform HTTP requests. Keeps default request parameters(base url, headers, request options, etc.)
* **Request** - HTTP request(method, uri, headers, body) with its options (e.g. `connect_timeout`).
* **Response** - HTTP response(method, headers, body).
* **Connection** - executes actual Request, used by Client and can be subsituted (e.g. for test purposes).
* **Middleware** - can be injected between Client and Connection to execute some custom stuff(e.g. logging, caching, etc.)

The following time diagram shows how it works:

![Crystal HTTP client Cossack time diagram](https://raw.githubusercontent.com/greyblake/crystal-cossack/master/images/cossack_diagram.png)

## Using Middleware

Middleware are custom classes that are injected in between Client and Connection. They allow you to intercept request or response and modify them.

Middleware class should be inherited from `Cossack::Middleware` and implement `#call(Cossack::Request) : Cossack::Response` interface.
It also should execute `app.call(request)` in order to forward a request.

Let's implement simple middleware that prints all requests:

```crystal
class StdoutLogMiddleware < Cossack::Middleware
  def call(request)
    puts "#{request.method} #{request.uri}"
    app.call(request).tap do |response|
      puts "Response: #{response.status} #{response.body}"
    end
  end
end
```

Now let's apply it to a client:

```crystal
cossack = Cossack::Client.new("http://example.org") do |client|
  client.use StdoutLogMiddleware
end

# Every request will be logged to STDOUT
response = cossack.get("/test")
```

Cossack has some preimplemented middleware, don't be afraid to [take a look](https://github.com/greyblake/crystal-cossack/tree/master/src/cossack/middleware).

## Connection Swapping

Connection is something, that receives Request and returns back Response. By default client as [HTTPConnection](https://github.com/greyblake/crystal-cossack/blob/master/src/cossack/connection/http_connection.cr),
that performs real HTTP requests. But if you don't like it by some reason, or you want to modify its behaviour, you can replace it
with you own. It must be a proc a subclass of `Cossack::Connection`:

```crystal
client = Cossack::Client.new
client.connection = -> (request : Cossack::Request) do
  Cossack::Response.new(200, "Everything is fine")
end

response = client.put("http://example.org/no/matter/what")
puts response.body # => "Everything is fine"
```

## Testing

There is more use of connection swapping, when it comes to testing. Cossack has `TestConnection` that allows you to
stub HTTP requests in specs.

```crystal
describe "TestConnection example" do
  it "stubs real requests" do
    connection = Cossack::TestConnection.new
    connection.stub_get("/hello/world", {200, "Hello developer!"})

    client = Cossack::Client.new("http://example.org")
    client.connection = connection

    response = client.get("/hello/world")
    response.status.should eq 200
    response.body.should eq "Hello developer!"
  end
end
```

You can find real examples in [Glosbe](https://github.com/greyblake/crystal-glosbe/blob/master/spec/glosbe/client_spec.cr) and
[GoogleTranslate](https://github.com/greyblake/crystal-google_translate/blob/master/spec/google_translate/client_spec.cr) clients.
Or in [Cossack specs](https://github.com/greyblake/crystal-cossack/blob/master/spec/unit/connection/test_connection_spec.cr) itself.

## FAQ

### How to follow redirections

If you want a client to follow redirections, you can use `Cossack::RedirectionMiddleware`:

```crystal
cossack = Cossack::Client.new do |client|
  # follow up to 10 redirections (by default 5)
  client.use Cossack::RedirectionMiddleware, limit: 10
end

cossack.get("http://example.org/redirect-me")
```

### How to persist cookies between requests

If, for example, you're calling an API that relies on cookies, you'll need to
use the `CookieJarMiddleware` like so:

```crystal
cossack = Cossack::Client.new do |client|
  # Other middleware goes here
end
cossack.use Cossack::CookieJarMiddleware, cookie_jar: cossack.cookies
```

Note that `cossack.use Cossack::CookieJarMiddleware` needs to be outside of the
`do ... end` block due to problems in Crystal (as of v0.18.7)

### How to persist cookies past the life of the application

If, for example, you have a need to retain cookies you're already storing
between requests, you have the option to write them out to a file using
something like the following:

```crystal
cossack = Cossack::Client.new do |client|
  # Other middleware goes here
end
cossack.use Cossack::CookieJarMiddleware, cookie_jar: cossack.cookies

# [code]

cossack.cookies.export_to_file("/path/to/writable/directory/cookies.txt")
```

You may also import the cookies like so:
```crystal
cossack = Cossack::Client.new do |client|
  # Other middleware goes here
end
cossack.cookies.import_from_file("/path/to/writable/directory/cookies.txt")

# OR

cossack = Cossack::Client.new do |client|
  client.cookies = Cossack::CookieJar.from_file("/path/to/writable/directory/cookies.txt")
  # Other middleware goes here
end
```

## Development

To run all tests:

```
make test
```

To run unit tests:

```
make test_unit
```

To run acceptance tests:

```
make test_acceptance
```

## Roadmap
* [ ] Implement before / after callbacks
* [ ] Add context/env Hash(String, String) to Request and Response
* [ ] Find a way to perform basic autentication

## Afterword

If you like the concept and design of the library, then may be we can bring the idea to Crystal!
There is no need to keep this library, if we can have the same things in standard library.
And I guess [crystal maintainers won't resist](https://github.com/crystal-lang/crystal/issues/2721#issuecomment-223399683).
But first we need to get positive feedback to ensure we're moving in the right direction =)

## Contributors

- [greyblake](https://github.com/greyblake) Sergey Potapov - creator, maintainer
- [thelonelyghost](https://github.com/thelonelyghost) David Alexander, cookie middleware support
