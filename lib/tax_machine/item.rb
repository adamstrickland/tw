module TaxMachine
  class Item
    attr_accessor :description
    attr_accessor :price
    attr_accessor :count
    attr_accessor :tax
    attr_accessor :imported
    
    def initialize(desc, price, args={})
      self.description = desc
      self.price = price
      self.count = args[:count] || 1
      self.imported = args[:imported] || false
      self.tax = args[:tax] || 0.0
    end
    
    def to_s
      "#{self.count} #{self.conjugated_description}: #{'%.2f' % self.total}"
    end
    
    def conjugated_description
      self.imported? ? "imported #{self.description}" : self.description
    end
    
    def total
      (self.price.to_f * self.count.to_i) + self.tax.to_f
    end
    
    def imported?
      @imported
    end
  end
end