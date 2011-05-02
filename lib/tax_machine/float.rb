module TaxMachine
  module Float
    def round_to(precision)
      (self * 10**precision).round.to_f / 10**precision
    end
    
    def ceil_to(precision)
      (self * 10**precision).ceil.to_f / 10**precision
    end
    
    def floor_to(precision)
      (self * 10**precision).floor.to_f / 10**precision
    end
  end
end

Float.send :include, TaxMachine::Float