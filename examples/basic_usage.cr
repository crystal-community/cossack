require "../src/cossack"

client = Cossack::Client.new("https://raw.githubusercontent.com")
response = client.get("/greyblake/crystal-cossack/master/README.md")

response.status # => 200
response.body   # => "Simple and flexible HTTP client for Crystal programming language..."
