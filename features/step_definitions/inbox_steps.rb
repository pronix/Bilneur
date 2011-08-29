Given /^I have (\d+) simple message when I is recipient$/ do |message_count|
  1.upto(message_count.to_i) { @message = Factory(:message, :recipient => @user )}
end

Then /^@message should be "(.+)" is "(.+)"$/ do |field, status|
  @message.send(field).should == eval(status)
end

Then /^I clink by class "(.+)"$/ do |class_name|
  find(".#{class_name}").click
end

Then /^execute jquery "(.+)"$/ do |script|
  page.execute_script(script)
end

Then /^message by subject "(.+)" should be "(.+)" is (.+)$/ do |subject, field, value|
  Message.find_by_subject(subject).send(field).should == eval(value)
end

Then /^message by subject "(.+)" should be "(.+)" a present$/ do |subject, field|
  Message.find_by_subject(subject).send(field).present?.should be_true
end


Then /^I execute script "(.+)"$/ do |script_name|
  case script_name
    when "inbox select_all_messages"
      page.execute_script %Q{ $('div.checkbox').css('background-position', '50% -50px');
                              $('div.checkbox').data('checked', true);
                              $(".multi_action").attr("checked", true)
                            }
    when "active reply"
      page.execute_script %Q{ $(".message_container").show();$(".replyer").hide(); }
    when "inbox send_as_read"
      page.execute_script %Q{ $('input[name=multi]').val('mark_as_read');$('#multi_form').submit(); }
    when "inbox send_as_unread"
      page.execute_script %Q{ $('input[name=multi]').val('mark_as_unread');$('#multi_form').submit(); }
    when "inbox send_delete"
      page.execute_script %Q{ $('input[name=multi]').val('delete');$('#multi_form').submit(); }
    when "inbox send_as_important"
      page.execute_script %Q{ $('input[name=multi]').val('mark_as_important');$('#multi_form').submit(); }
  end
end


Then /^I wait for the AJAX call to finish$/ do
  keep_looping = true
  # FIXME add counter
  while keep_looping do
    sleep 1
    begin
      count = page.evaluate_script('window.running_ajax_calls').to_i
      keep_looping = false if count == 0
    rescue => e
      if (e.message.include? 'HTMLunitCorejsJavascript::Undefined')
        raise "For 'I wait for the AJAX call to finish' to work, please include culerity.js after including jQuery."
      else
        raise e
      end
    end
  end
end

Then /^All my message should be read$/ do
  @user.messages.roots.each { |message| message.recipient_read.should be_true }
end
