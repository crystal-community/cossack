module Cossack
  class RequestOptions
    property connect_timeout : Float64
    property read_timeout : Float64

    def initialize(connect_timeout : Number|Time::Span = 30.0, read_timeout : Number|Time::Span = 30.0)
      @connect_timeout = connect_timeout.to_f
      @read_timeout = read_timeout.to_f
    end

    def connect_timeout=(val : Number|Time::Span)
      @connect_timeout = val.to_f
    end

    def read_timeout=(val : Number|Time::Span)
      @read_timeout = val.to_f
    end
  end
end
