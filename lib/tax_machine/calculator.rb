module TaxMachine
  class Calculator
    DEFAULT_RATE = 0.10
    
    attr_accessor :rate
    
    def initialize(args={})
      args[:rate] ||= DEFAULT_RATE
      self.rate = args[:rate]
    end

    def taxify(amount, count=1)
      return TaxMachine::Calculator.taxify(amount, self.rate, count)
    end

    def calculate(amount, count=1)
      return TaxMachine::Calculator.calculate(amount, self.rate, count)
    end
    
    def self.taxify(amount, rate, count=1)
      return self.roundify(((amount * count) * rate).to_f)
    end
    
    def self.calculate(amount, rate, count=1)
      return ((amount * count) + self.taxify(amount, rate, count)).to_f
    end
    
    def self.roundify(amount)
      return ((amount.to_f * 20).ceil / 20.0)
    end
  end
end