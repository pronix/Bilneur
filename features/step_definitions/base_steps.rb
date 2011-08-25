Then /^exec "(.+)"$/ do |command|
  puts eval(command)
end
