require "../src/cossack"

cossack = Cossack::Client.new

#cossack.connection = -> (req : Cossack::Request) { Cossack::Response.new(200, HTTP::Headers.new, "") }


#response = cossack.get("test")
#pp response
