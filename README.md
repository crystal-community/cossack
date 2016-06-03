# Cossack <img src="https://cloud.githubusercontent.com/assets/113512/15764341/65d90c06-292a-11e6-8f91-44ed93e024f8.png" alt="crystal Cossack logo" width="48">

Simple and flexible HTTP client for Crystal programming language.

## Roadmap
* [x] Middleware support
* [x] Use URI to parse URL
* [x] Allow `Client` be initialized with base `url`
* [x] support headers for individual request
* [x] support headers for Client
* [ ] Support of all HTTP verbs
  * [x] get
  * [x] post
  * [x] put
  * [x] patch
  * [x] delete
  * [ ] head
  * [ ] options
* [ ] Implement class methods, like `Cossack.get`, `Cossack.post`, etc..
* [ ] Swapping connections [like Hurley does](https://github.com/lostisland/hurley#connections)
* [ ] Follow redirections
* [ ] SSL
* [ ] Examples
* [ ] Timeout
* [ ] Proxy
* [ ] Proper unit tests for what's already written
* [ ] Good documentation, describing the concept and usage.

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
