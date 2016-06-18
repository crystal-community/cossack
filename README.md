# Cossack <img src="https://cloud.githubusercontent.com/assets/113512/15764341/65d90c06-292a-11e6-8f91-44ed93e024f8.png" alt="crystal Cossack logo" width="48">

[![Build Status](https://travis-ci.org/greyblake/crystal-cossack.svg?branch=master)](https://travis-ci.org/greyblake/crystal-cossack)
[![docrystal.org](http://docrystal.org/badge.svg?style=round)](http://docrystal.org/github.com/greyblake/crystal-cossack)

Simple and flexible HTTP client for Crystal with middleware and test support.

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  cossack:
    github: greyblake/crystal-cossack
```

And install dependencies:

```
crystal deps
```

## Usage

```crystal
require "cossack"

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
* **Request** - HTTP request(method, uri, headers, body) with its options (e.g. connect_timeout`).
* **Response** - HTTP response(method, headers, body).
* **Connection** - executes actual Request, used by Client and can be subsituted (e.g. for test purposes).
* **Middleware** - can be injected between Client and Connection to execute some custom stuff(e.g. logging, caching, etc.)

The following time diagram shows how it works:

![Crystal HTTP client Cossack time diagram](https://raw.githubusercontent.com/greyblake/crystal-cossack/master/images/cossack_diagram.png)

### Using Middleware

Middleware are custom classes that are injected in between Client and Connection. They allow you to intercept request or response and modify them.

Middleware class should be inherited from `Cossack::Middleware` and implement `#call(Cossack::Request) : Cossack::Response` interface.
It also should execute `app.call(request)` in order to forward a request.

Let's implement simple middleware that prints all requests:

```crystal
class StdoutLogMiddleware < Cossack::Middleware
  call(request)
    puts "#{request.method} #{request.uri}"
    response = app.call(request)
    puts "Response: #{response.status} #{response.body}"
    response
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

### Connection Swapping

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

### Testing

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
* [x] Middleware support
* [x] Use URI to parse URL
* [x] Allow `Client` be initialized with base `url`
* [x] support headers for individual request
* [x] support headers for Client
* [x] Support of all HTTP verbs
  * [x] get
  * [x] post
  * [x] put
  * [x] patch
  * [x] delete
  * [x] head
  * [x] options
* [x] Implement class methods, like `Cossack.get`, `Cossack.post`, etc..
* [x] Swapping connections [like Hurley does](https://github.com/lostisland/hurley#connections)
* [x] Timeout
* [x] Move `connect_timeout` and `read_timeout` opts to Request object. Introduce RequestOptions.
* [x] Extract Client#call method
* [x] Implement TestConnection (ConnectionMock)
* [x] Unit tests
* [x] Rename HttpConnection -> HTTPConnection (it's Crystal convention)
* [x] Beta test of API
  * [x] Update GoogleTranslate client to use Cossack
  * [x] Update Glosbe client to use Cossack
* [x] Follow redirections
  * [x] Introduce `redirection_limit` option in RequestOptions (CANCELED)
  * [x] Implement RedirectionMiddleware
  * [x] Acceptance tests
  * [x] Unit tests
* [x] Rename method Client#add_middleware -> Client#use
* [x] Additional sugar
  * [x] Pass headers to Response.new and Request.new as Hash(String, String)
  * [x] Add methods to Response: redirection?, client_error?, server_error?
* [x] Acceptance tests
* [x] MockError -> StubError
* [x] Remove `Client#set_connection` method
* [x] Setup TravisCI and Crystal doc badges
* [x] Add LGPL license (tweak shard.yml also)
* [ ] Examples
* [ ] Good documentation, describing the concept and usage.
  * [x] Docs for code base
  * [ ] README docs
    * [x] Getting started example
    * [x] Basic concept: Request, Response, Client, Connection. (Middleware?)
    * [ ] Advanced usage
      * [ ] Middleware
    * [ ] Testing
    * [ ] FAQ
      * [ ] How to send headers?
      * [ ] How to handle basic authentication?
      * [ ] Follow redirections
* [ ] First release!
* [x] Open PR to awesome-crystal
* [ ] Implement before / after callbacks
* [ ] Add context/env Hash(String, String) to Request and Response

## Contributors

- [greyblake](https://github.com/greyblake) Sergey Potapov - creator, maintainer
