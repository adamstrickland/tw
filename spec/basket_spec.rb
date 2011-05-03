require 'spec_helper'

describe TaxMachine::Basket do
  before :each do
    @killozap = TaxMachine::Item.new("Kill-o-Zap", 100.00, {:tax => 5.42})
    @pggb = TaxMachine::Item.new("Pan Galactic Gargle Blaster", 763.21, {:tax => 8.77})
    @items = [@killozap, @pggb]
    @options = {
      :items => @items
    }
    @basket = TaxMachine::Basket.new(@options)
  end
    
  subject { @basket }
  
  describe :sales_tax do
    subject{ @basket.sales_tax }
    it{ should eql (@killozap.tax + @pggb.tax) }
  end
  
  describe :total do
    subject{ @basket.total }
    it{ should eql (@killozap.total + @pggb.total) }
  end
  
  describe :to_s do
    subject{ @basket.to_s }
    it{ should eql <<-EOS }
1 #{@killozap.description}: #{@killozap.total}
1 #{@pggb.description}: #{@pggb.total}
Sales Taxes: #{@basket.sales_tax}
Total: #{'%.2f' % @basket.total}
EOS
  end
  
  describe :print do
    subject{ @basket.print }
  end
end