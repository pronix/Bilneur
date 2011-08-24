Then /^I attach "(.+)" file with "(.+)"$/ do |file, field|
  attach_file(field, File.join(Rails.root, 'features', 'support', 'test_img', 'ruby.png'))
end

Then /^I should see that I have "(.+)" photo$/ do |photo_name|
  @user.photo.present?.should be_true
end
