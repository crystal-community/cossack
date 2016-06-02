# Cossack

Simple and flexible HTTP client for Crystal programming language.

## Roadmap
* [x] Middleware support
* [x] Use URI to parse URL
* [x] Allow `Client` be initialized with base `url`
* [ ] Support Symbols, Integers, Floats in params (must be coerced to strings)
* [ ] Support of all HTTP verbs `get`, `post`, `put`, `patch`, `delete`, `head`, `options`
* [ ] Follow redirections
* [ ] SSL
* [ ] Examples
* [ ] Swapping connections [like Hurley does](https://github.com/lostisland/hurley#connections)
* [ ] Timeout
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

To run specs:

```
crystal spec
```

## Contributors

- [greyblake](https://github.com/greyblake) Sergey Potapov - creator, maintainer
