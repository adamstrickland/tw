require 'spec_helper'

describe TaxMachine::Item do
  before :each do
    @description = "Kill-o-Zap"
    @price = 123.45
  end
    
  describe "with defaults" do
    before :each do
      @item = TaxMachine::Item.new(@description, @price)
    end

    subject{ @item }
  
    describe :description do
      subject{ @item.description }
      it{ should eql @description }
    end
  
    describe :price do
      subject{ @item.price }
      it{ should eql @price }
    end
  
    describe :imported? do
      subject{ @item.imported }
      it{ should be_false }
    end
     
    describe :tax do
      subject{ @item.tax }
      it{ should eql 0.0 }
    end
  
    describe :total do
      subject{ @item.total }
      it{ should eql @price }
    end
  
    describe :count do
      subject{ @item.count }
      it{ should eql 1 }
    end
  
    describe :conjugated_description do
      subject{ @item.conjugated_description }
      it{ should eql @description }
    end
  
    describe :to_s do
      subject{ @item.to_s }
      it{ should eql "1 #{@description}: #{@price}" }
    end
  end

  describe "with non-defaults" do
    before :each do
      @imported = true
      @tax = 23.31
      @count = 4
      @options = {
        :imported => @imported,
        :tax => @tax,
        :count => @count
      }
      @item = TaxMachine::Item.new(@description, @price, @options)
    end

    subject{ @item }
    
    describe :description do
      subject{ @item.description }
      it{ should eql @description }
    end

    describe :price do
      subject{ @item.price }
      it{ should eql @price }
    end

    describe :imported? do
      subject{ @item.imported }
      it{ should be_true }
    end

    describe :tax do
      subject{ @item.tax }
      it{ should eql @tax }
    end

    describe :total do
      subject{ @item.total }
      it{ should eql ((@price * @count) + @tax) }
    end

    describe :count do
      subject{ @item.count }
      it{ should eql @count }
    end

    describe :conjugated_description do
      subject{ @item.conjugated_description }
      it{ should eql "imported #{@description}" }
    end

    describe :to_s do
      subject{ @item.to_s }
      it{ should eql "#{@count} imported #{@description}: #{(@price * @count) + @tax}" }
    end
  end
end