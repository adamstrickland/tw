module TaxMachine
  class Configuration
    attr_accessor :pattern
    attr_accessor :registers
    attr_accessor :exceptions
    attr_accessor :options
    attr_accessor :rate
    
    def initialize(options={})
      self.pattern = options[:pattern] || %r{^([0-9]+)\s(.+)\s([0-9]+\.[0-9]{2})$}
      self.rate = options[:rate] || 0.10
      self.registers = options[:registers] || {}
      self.exceptions = options[:exceptions] || []
      self.options = options[:options] || {}
    end
  end
end