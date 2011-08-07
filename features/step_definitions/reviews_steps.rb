Then /^sleep "(\d+)"$/ do |time|
  sleep time.to_i
end

Given /^the following products was created by  "(.+)" user:$/ do |user_email, table|
  user = User.find_by_email(user_email)
  table.hashes.each do |product|
    user.products.create(product)
  end
  p Product.count
end
