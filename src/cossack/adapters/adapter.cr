module Cossack
  abstract class Adapter
    abstract def call(env : Env) : Env
  end
end
