require 'spec_helper'

describe TaxMachine::Calculator do
  before :each do
    @rate = 0.10
    @subject = TaxMachine::Calculator.new(:rate => @rate)
  end
  
  it "should use a ${rate}% rate" do
    @subject.rate.should eql @rate
  end  

  it "should round a float up to the nearest $0.05" do
    TaxMachine::Calculator.roundify(0.00).should eql 0.0
    TaxMachine::Calculator.roundify(0.001).should eql 0.05
    TaxMachine::Calculator.roundify(0.01).should eql 0.05
    TaxMachine::Calculator.roundify(0.011).should eql 0.05
    TaxMachine::Calculator.roundify(0.06).should eql 0.10
  end
  
  describe "when calculating" do
    describe "a regular amount" do
      before :each do
        @amount = 10.0
      end

      it "should calculate the tax" do
        @subject.taxify(@amount).should eql (@amount * @rate)
      end

      it "should total the amount" do
        @subject.calculate(@amount).should eql (@amount + (@amount * @rate))
      end

      describe "multiples" do
        before :each do
          @count = 3
        end
      
        it "should multiply first, then taxify" do
          @subject.taxify(@amount, @count).should eql ((@amount * @count) * @rate)
        end
      end  
    end
    
    describe "an irregular amount" do
      before :each do
        @amount = 123.13
      end

      it "should calculate the tax" do
        @subject.taxify(@amount).should eql 12.35
      end

      it "should total the amount" do
        @subject.calculate(@amount).should eql 135.48
      end

      describe "multiples" do
        before :each do
          @count = 3
        end

        it "should multiply first, then taxify" do
          @subject.taxify(@amount, @count).should eql 36.95
        end
        
        it "should calculate the total" do
          @subject.calculate(@amount, @count).should eql 406.34
        end
      end  
    end
  end
end