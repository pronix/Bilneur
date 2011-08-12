require 'spec_helper'

describe Message do
  describe "validation" do

    describe "of associated sender" do
      it "fails if sender is null" do
        message = Factory.create(:message)
        message.should be_valid
        message.sender = nil
        message.should_not be_valid
        message.errors.full_messages.count.should == 1
        message.errors.full_messages.first.should =~ /Sender can't be blank/i
      end
    end

    describe "of associated recipient" do
      it "fails if recipient is null" do
        message = Factory.create(:message)
        message.should be_valid
        message.recipient = nil
        message.should_not be_valid
        message.errors.full_messages.count.should == 1
        message.errors.full_messages.first.should =~ /Recipient can't be blank/i

      end
    end

    describe "of subject" do
      it "requires presence" do
        message = Factory.create(:message)
        message.subject = nil
        message.should_not be_valid
        message.errors.full_messages.first.should =~ /Subject can't be blank/i
      end
      it "can be 250 characters long" do
        message = Factory.create(:message)
        message.subject = "u"*250
        message.should be_valid
      end
      it "cannot be 251 characters long" do
        message = Factory.create(:message)
        message.subject = "u"*251
        message.should_not be_valid
        message.errors.full_messages.first.should =~ /Subject is too long/i
      end

    end

    describe "of content" do
      it "requires presence" do
        message = Factory.create(:message)
        message.content = nil
        message.should_not be_valid
        message.errors.full_messages.first.should =~ /Content can't be blank/i
      end
    end

  end # end validation

  context 'scopes' do

    describe '.read' do
      it 'returns only read messages' do
        @message = Factory.create(:message,{ :recipient_read => true } )
        Message.read.should eq([@message])
      end
    end

    describe '.unread' do
      it 'returns only unread messages' do
        @user = Factory(:user)
        @message = Factory.create(:message,{ :recipient => @user,  :recipient_read => false } )
        @message1 = Factory.create(:message,{ :recipient => @user,  :recipient_read => true } )
        @message2 = Factory.create(:message,{ :recipient_read => true } )
        Message.unread(@user).should eq([@message])
      end
    end

    describe '.deleted' do
      it 'returns only deleted messages' do
        @user = Factory(:user)
        @message = Factory.create(:message,{ :recipient => @user,  :recipient_deleted_at => Time.now } )
        @message1 = Factory.create(:message,{ :sender => @user,  :sender_deleted_at => Time.now } )
        @message2 = Factory.create(:message,{ :sender => @user} )
        deleted_message = Message.deleted(@user)
        deleted_message.should include(@message)
        deleted_message.should include(@message1)
        deleted_message.should_not include(@message2)

      end
    end

    describe '.trash' do
      it 'should equal scopes.deleted' do
        @user = Factory(:user)
        @message = Factory.create(:message,{ :recipient => @user,  :recipient_deleted_at => Time.now } )
        @message1 = Factory.create(:message,{ :sender => @user,  :sender_deleted_at => Time.now } )
        @message2 = Factory.create(:message,{ :sender => @user} )
        Message.deleted(@user).should eq(Message.trash(@user))
      end
    end

    describe '.undeleted' do
      it 'returns only undeleted messages' do
        @user = Factory(:user)
        @message = Factory.create(:message,{ :recipient => @user,  :recipient_deleted_at => Time.now } )
        @message1 = Factory.create(:message,{ :sender => @user,  :sender_deleted_at => Time.now } )
        @message2 = Factory.create(:message,{ :sender => @user} )
        undeleted_message = Message.undeleted(@user)
        undeleted_message.should_not include(@message)
        undeleted_message.should_not include(@message1)
        undeleted_message.should include(@message2)
      end
    end

    describe '.messages_for_user' do
      it 'returns all messages for user' do
        @user = Factory(:user)
        @user1 = Factory(:user)
        @user2 = Factory(:user)
        @user3 = Factory(:user)
        @message = Factory.create(:message,{  :recipient => @user})
        @message1 = Factory.create(:message,{ :sender => @user})
        @message2 = Factory.create(:message,{ :sender => @user1} )
        @message3 = Factory.create(:message,{ :sender => @user2} )
        @message4 = Factory.create(:message,{ :sender => @user3} )
        messages = Message.messages_for_user(@user)
        messages.should include(@message)
        messages.should include(@message1)
        messages.should_not include(@message2)
        messages.should_not include(@message3)
        messages.should_not include(@message4)
      end
    end

    describe '.important' do
      it 'returns all messages with marker important' do
        @user = Factory(:user)
        @message = Factory.create(:message,{  :recipient => @user, :recipient_marker => 'important'})
        @message1 = Factory.create(:message,{  :recipient => @user, :sender_marker => 'important'})
        @message2 = Factory.create(:message,{ :sender => @user,:sender_marker => 'important' })
        important_messages = Message.important(@user)
        important_messages.should include(@message)
        important_messages.should include(@message2)
        important_messages.should_not include(@message1)
      end

    end


  end # scopes

end
