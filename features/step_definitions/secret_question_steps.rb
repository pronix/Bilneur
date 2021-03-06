Then /^test pls$/ do
  puts User.last.secret_question.id
end

Given /^I should see in "(.+)" all public questions$/ do |field|
  SecretQuestionVariant.public.each do |variant|
    page.select variant.variant, :from => field
  end
end

Given /^I already have secret question "(.+)" with answer "(.+)"$/ do |secret, answer|
  @user.create_secret_question(:answer => answer, :secret_question_variant => SecretQuestionVariant.find_by_variant(secret))
end

Then /^I should see my question on the "(.+)"$/ do |field|
  find_field(field).value.should eq(@user.secret_question.secret_question_variant_id.to_s)
end

Then /^I should see my answer on the "(.+)"$/ do |field|
  find_field(field).value.should eq(@user.secret_question.answer)
end

Given /^"(.+)" should be invisible$/ do |element|
  find_by_id(element).should_not be_visible
  page.has_xpath?("//div[@style='display:none;' and @id='#{element}']")
end

Then /^"(.+)" should be visible$/ do |element|
  find_by_id(element).should be_visible
  page.has_xpath?("//div[@style='display:none;' and @id='#{element}']")
end

Given /^I have a own question "(.+)" with answer "(.+)"$/ do |question, answer|
  variant = SecretQuestionVariant.create(:variant => question, :private => true)
  @user.create_secret_question(:answer => answer, :secret_question_variant => variant)
end

Then /^"(.+)" should be selected for "(.+)"$/ do |field, question|
  find_field(field).value.should eq(SecretQuestionVariant.find_by_variant(question).id.to_s)
end

Given /^some test question$/ do
  SecretQuestionVariant.created(:variant => 'TEST VARIANT', :private => true)
end

Given /^I have regular question "(.+)" with answer "(.+)"$/ do |question, answer|
  variant = SecretQuestionVariant.find_by_variant(question)
  @user.create_secret_question(:answer => answer, :secret_question_variant => variant)
end

Then /^I fill in "(.+)" with my email$/ do |field|
  fill_in(field, :with => @user.email)
end
