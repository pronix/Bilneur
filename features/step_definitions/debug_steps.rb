When 'I debug' do
  debugger
  true
end

Then /^inspect all products/ do
  puts "="*90
  puts Product.all.inspect
  puts "="*90
end
