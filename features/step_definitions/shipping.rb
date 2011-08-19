When /^calculator weight_rate '([^\']*?)'$/ do |interval|
  s = ShippingMethod.new(:name => 'weight')
  s.zone = Zone.first
  s.calculator = Calculator::WeightRate.new
  c = s.calculator
  c.preferred_interval = interval
  c.calculable_id = c.object_id
  s.save
end

Then /^I get shipping adjustment 40 for order "([^\"]*?)"$/ do |num|
  @o = Order.find_by_number(num)
  s = ShippingMethod.find_by_name('weight')
  s.calculator.compute(@o).should == 40
end

