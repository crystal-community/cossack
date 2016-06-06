module Cossack
  abstract class Connection
    abstract def call(request : Request) : Response
  end
end
