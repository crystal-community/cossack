# Cossack

Simple and flexible HTTP client for Crystal programming language.

## Roadmap
* [ ] Use URI to parse URL
* [ ] Allow `Client` be initialized with base `url`
* [ ] Support of all HTTP verbs `get`, `post`, `put`, `patch`, `delete`, `head`, `options`
* [ ] Examples
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
