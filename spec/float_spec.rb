require 'spec_helper'

describe Float do
  before :each do
    @num = 138.249
  end
  
  it "should round to 2 places" do
    @num.round_to(2).should eql 138.25
  end
  
  it "should floor to 2 places" do
    @num.floor_to(2).should eql 138.24
  end
  
  it "should round to -1 places" do
    @num.round_to(-1).should eql 140.0
  end
end