require 'tax_machine/item'

module TaxMachine
  class Basket
    attr_accessor :items
    
    def initialize(args={})
      args[:items] ||= []
      self.items = args[:items]
    end
    
    def sales_tax
      self.items.inject(0){ |sum, item| sum + item.tax }
    end
    
    def total
      self.items.inject(0){ |sum, item| sum + item.total }
    end
    
    def to_s
      output = ""
      self.items.each do |item|
        output += "#{item.to_s}\n"
      end
      output += "Sales Taxes: #{'%.2f' % self.sales_tax}\n"
      output += "Total: #{'%.2f' % self.total}\n"
      output
    end
    
    def print
      puts self.to_s
    end
  end
end