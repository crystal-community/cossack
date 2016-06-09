require "../src/cossack"

# Schema and host in base URL
cossack = Cossack::Client.new("http://jsonplaceholder.typicode.com", connect_timeout: 0.2)
response = cossack.get("/posts", {"postId" => "1"})
pp response.status
puts response.body[0..100].gsub("\n", " ").gsub(/\s+/, " ")
puts


# Schema, host and some path in base URL
cossack = Cossack::Client.new("http://jsonplaceholder.typicode.com/posts/1/")
response = cossack.get("/comments")
pp response.status
puts response.body[0..100].gsub("\n", " ").gsub(/\s+/, " ")
puts

