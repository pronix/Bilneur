When /^"([^\"]*)" has my message in the Sent$/ do |email|
  user = User.find_by_email(email)
  user.sent.count.should eq(1)
end

When /^user "([^\"]*)" has my message in the Received tab$/ do |email|
  user = User.find_by_email(email)
  user.inbox.count.should eq(1)
end

Given /^the following messages exist:$/ do |table|
  table.hashes.each do |item|

    Factory(:message, { :created_at => Time.parse(item["created_at"]),
            :sender_id => User.find_by_email(item["sender"]).id,
            :recipient_id => User.find_by_email(item["recipient"]).id,
            :subject => item["subject"],
              :content => item["message"]})
  end
end
