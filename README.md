# Cossack <img src="https://cloud.githubusercontent.com/assets/113512/15764341/65d90c06-292a-11e6-8f91-44ed93e024f8.png" alt="crystal Cossack logo" width="48">

Simple and flexible HTTP client for Crystal programming language.

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
* [ ] Extract Client#exec method
* [ ] Implement TestConnection
* [ ] Try to separate request builders from #get, #post, etc., methods.
* [ ] Add methods to Response: redirection?, client_error?, server_error?
* [ ] Rename Connection -> Handler ?
* [x] Unit tests
* [ ] Beta test of API
  * [ ] Update GoogleTranslate client to use Cossack
  * [x] Update Glosbe client to use Cossack
* [ ] Follow redirections
* [ ] Examples
* [ ] Additional sugar
  * [x] Pass headers to Response.new and Request.new as Hash(String, String)
  * [ ] Add `:headers` argument to http methods
  * [x] status methods for response success?
* [x] Acceptance tests
* [ ] Good documentation, describing the concept and usage.
  * [ ] Docs for code base
  * [ ] README docs
    * [ ] Getting started example
    * [ ] Basic concept: Request, Response, Client, Connection. (Middleware?)
    * [ ] Advanced usage
      * [ ] Middleware
    * [ ] Testing
    * [ ] FAQ
      * [ ] How to send headers?
      * [ ] How to handle basic authentication?
* [ ] Add LGPL license
* [ ] First release!
* [ ] Open PR to awesome-crystal

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

cossack = Cossack.new
cossack.get("http://some.url/path")
```

## Development

To run test:

```
make test
```

## Contributors

- [greyblake](https://github.com/greyblake) Sergey Potapov - creator, maintainer
