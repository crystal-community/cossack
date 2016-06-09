require "../src/cossack"

TEST_SERVER_URL = "http://localhost:3999"
client = Cossack::Client.new("#{TEST_SERVER_URL}", read_timeout: 0.2)
client.get("/delay/2")
