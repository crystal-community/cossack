require "../spec_helper"

Spec2.describe "Timeout options" do
  describe "read_timeout" do
    it "raises TimeoutError if response takes too long" do
      client = Cossack::Client.new("#{TEST_SERVER_URL}")
      client.request_options.read_timeout = 0.02

      response = client.get("/delay/0.01")
      expect(response.body).to eq "0.01"

      expect { client.get("/delay/0.03") }.to raise_error(Cossack::TimeoutError)
    end
  end

  describe "connect_timeout" do
    it "raises TimeoutError if connection is not established during given time" do
      client = Cossack::Client.new("#{TEST_SERVER_URL}")
      client.request_options.connect_timeout = 0.02

      response = client.get("/")
      expect(response.status).to eq 200

      # Super small time, so exception should be raise
      client = Cossack::Client.new("#{TEST_SERVER_URL}")
      client.request_options.connect_timeout = 0.00000001
      expect { client.get("/") }.to raise_error(Cossack::TimeoutError)
    end
  end
end
