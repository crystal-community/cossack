require "http"
require "uri"

require "./cossack/**"

module Cossack
  alias Params = Hash(String, String)

  class Error < Exception; end
end
