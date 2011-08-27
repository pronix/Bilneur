Given /^I have (\d+) simple message when I is recipient$/ do |message_count|
  1.upto(message_count.to_i) { @message = Factory(:message, :recipient => @user )}
end

Then /^@message should be "(.+)" is "(.+)"$/ do |field, status|
  @message.send(field).should == eval(status)
end
