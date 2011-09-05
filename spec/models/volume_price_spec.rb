require 'spec_helper'

describe VolumePrice do

  it "show range '(4+)'" do
    volume_price = Factory(:volume_price, :range => "(4+)")
    volume_price.start_range.should == 4
    volume_price.end_range.should == nil
  end

  it "show range '(1..2)'" do
    volume_price = Factory(:volume_price, :range => "(1..2)")
    volume_price.start_range.should == 1
    volume_price.end_range.should == 2
  end

  it "show range '(2...6)'" do
    volume_price = Factory(:volume_price, :range => "(2...6)")
    volume_price.start_range.should == 3
    volume_price.end_range.should == 5
  end

  it "check start_end_2_range method 3..6" do
    volume_price = Factory.build(:volume_price, :range => "", :start_range => 3, :end_range => 6)
    volume_price.start_end_2_range
    volume_price.range.should == "(3..6)"
  end

  it "check start_end_2_range method 3+" do
    volume_price = Factory.build(:volume_price, :range => "", :start_range => 3)
    volume_price.start_end_2_range
    volume_price.range.should == "(3+)"
  end

  it "check start_end_2_range method with ''" do
    volume_price = Factory.build(:volume_price, :range => "")
    volume_price.start_end_2_range
    volume_price.range.should == ""
  end

  it "when we save volume price with start and end 2 and 5" do
    volume_price = VolumePrice.create(:variant => Factory(:variant), :start_range => 2, :end_range => 5)
    volume_price.range.should == "(2..5)"
  end

  it "when we save volume price with only start by 2" do
    volume_price = VolumePrice.create(:variant => Factory(:variant), :start_range => 2)
    volume_price.range.should == "(2+)"
  end

  it "show me error when I not have start_r" do
    volume_price = VolumePrice.create(:variant => Factory(:variant))
    volume_price.errors[:range].last.should == 'You should at least indicate the start range'
  end

  it "show me error when I set only end_r" do
    volume_price = VolumePrice.create(:variant => Factory(:variant), :end_range => 2)
    volume_price.errors[:range].last.should == 'You should at least indicate the start range'
  end

  it "check update_attributes" do
    volume_price = Factory(:volume_price)
    volume_price.update_attributes(:start_range => 2, :end_range => 10)
    volume_price.range.should == "(2..10)"
  end

  it "autochange display by 3..6" do
    volume_price = Factory(:volume_price, :start_range => 3, :end_range => 6)
    volume_price.display.should == "3 to 6"
  end

  it "autochange display by 3+" do
    volume_price = Factory(:volume_price, :start_range => 3)
    volume_price.display.should == "3 and more"
  end

end
