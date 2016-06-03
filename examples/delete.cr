require "../src/cossack"

client = Cossack::Client.new("http://localhost:3000")

response = client.delete("/http/reflect", "korpo")

pp response
