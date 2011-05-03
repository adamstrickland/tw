require 'spec_helper'

# @config = TaxMachine::Configuration.new({
#   :pattern => %r{^([0-9]+)\s(.*imported.*)\sat\s([0-9]+\.[0-9]{2})$},
#   :rate => 0.05,
#   :registers => {
#     :count => 0,
#     :description => 1,
#     :price => 2,
#   },
#   :options => {
#     :imported => true
#   },
#   :exceptions => []
# })


describe TaxMachine::Register do
  describe "when using a simple configuration" do
    before :each do
      @rate = 0.05
      @re = %r{^([0-9]+)\s(.+)\s([0-9]+\.[0-9]{2})$}
      @config_options = {
        :pattern => @re,
        :rate => @rate,
        :registers => {
          :count => 1,
          :description => 2,
          :price => 3,
        },
      }
      @config = TaxMachine::Configuration.new(@config_options)
      @register = TaxMachine::Register.new([@config])
    end
  
    subject{ @register }
    
    describe :basket do
      subject{ @register.basket }
      
      describe :items do
        subject{ @register.basket.items }
        it{ should be_empty }
      end
    end
    
    describe :configs do
      subject{ @register.configs }
      it{ should have(1).items }
    end
    
    describe "inputs" do
      before :each do
        @description = "Kill-o-Zap"
        @amount = 1
        @price = 649.38
        @input = "#{@amount} #{@description} #{@price}"
      end
      
      it "test the input just to make sure" do
        (@input =~ @re).should_not be_nil
        $1.to_i.should eql @amount
        $2.should eql @description
        $3.to_f.should eql @price
      end
      
      # describe "find a match" do
      #   it "should find one" do
      #     @register.find_match(@input).should eql 0
      #   end
      # end
      
      describe "parsing" do
        subject{ @register.parse(@input) }
        it{ subject.description.should eql @description }
        it{ subject.count.should eql @amount.to_s }
        it{ subject.price.should eql @price.to_s }
        it{ subject.tax.should eql TaxMachine::Calculator.roundify(@price * @rate)}
      end
      
      describe "with exceptions" do
        before :each do
          @exception = {
            :attribute => :description,
            :pattern => %r{^.*Zap.*$}
          }
          
          @config = TaxMachine::Configuration.new(@config_options.merge(:exceptions => [@exception]))
          @register = TaxMachine::Register.new([@config])
        end
        
        subject{ @register.parse(@input) }
        it{ subject.tax.should eql 0.0 }
      end
    end
  end
end