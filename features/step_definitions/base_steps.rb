Then /^exec "(.+)"$/ do |command|
  puts eval(command)
end

Then /^silent exec "(.+)"$/ do |command|
  eval(command)
end

