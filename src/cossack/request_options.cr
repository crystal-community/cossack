module Cossack
  class RequestOptions
    property connect_timeout : Float64
    property read_timeout : Float64

    def initialize
      @connect_timeout = 30.0
      @read_timeout = 30.0
    end

    def connect_timeout=(val : Number|Time::Span)
      @connect_timeout = val.to_f
    end

    def read_timeout=(val : Number|Time::Span)
      @read_timeout = val.to_f
    end
  end
end
