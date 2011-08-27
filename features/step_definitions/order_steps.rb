Then /^page have the following orders:$/ do |table|
  table.diff!(tableish('table:first tr', 'td,th'))
end
