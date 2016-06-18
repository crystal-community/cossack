require "../src/cossack"

client = Cossack::Client.new("https://raw.githubusercontent.com")
client.connection = -> (request : Cossack::Request) do
  Cossack::Response.new(200, "Everything is fine")
end

response = client.put("/no/matter/what")
puts response.body # => "Everything is fine"
