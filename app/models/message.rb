class Message < ActiveRecord::Base

  # dsl
  #

  has_ancestry

  # associations
  #

  belongs_to :sender, :class_name => "User"
  belongs_to :recipient, :class_name => "User"

  # scopes
  #
  scope :read, where(:recipient_read => true)

  scope :unread,lambda{ |*args|
    if (user = (args.first || User.current))
    where("(recipient_read = :v and recipient_id = :user_id) or (sender_read = :v and sender_id = :user_id) ",
          { :v => false, :user_id => user.id})
    end
  }

  scope :deleted, lambda{ |*args|
    if (user = (args.first || User.current))
      where("(sender_id = :user_id AND sender_deleted_at is not :v) OR
           (recipient_id =:user_id AND recipient_deleted_at is not :v) ",{ :v => nil, :user_id => user.id })
    end
  }

  scope :trash, lambda{ |*args| deleted(*args) }

  scope :undeleted, lambda{ |*args|
    if (user = (args.first || User.current))
      where("(sender_id = :user_id AND sender_deleted_at is :v)
           OR ( recipient_id = :user_id AND recipient_deleted_at is :v ) ",{ :v => nil, :user_id => user.id })
    end
  }

  scope :messages_for_user, lambda{ |user|
    where("messages.sender_id = :user_id OR messages.recipient_id = :user_id ", { :user_id => user.id })
  }

  scope :important, lambda{  |*args|
    if (user = (args.first || User.current))
      where("(sender_id = :user_id AND sender_marker = :v )
           OR ( recipient_id = :user_id AND recipient_marker = :v ) ",{ :v => 'important', :user_id => user.id })
    end
  }


  # validates
  #
  validates :content, :sender, :recipient, :presence => true
  validates :subject, :presence => true, :length => { :maximum => 250 }


  # callbacks
  #
  after_create :refresh_read_status!


  # instance methods
  #
  def refresh_read_status!

    parent.children.unread.where(:recipient_id => sender.id).update_all(:recipient_read => true) unless is_root?

    if sender == parent.recipient
      parent.update_attribute(:recipient_read,true)
      parent.update_attribute(:sender_read, false)
    else
      parent.update_attribute(:recipient_read,false)
      parent.update_attribute(:sender_read, true)

    end unless is_root?
  end

  def read!
    update_attribute(:recipient_read, true)
  end

  def deleted!(user = User.current)
    update_attribute(get_field(user, :deleted_at), Time.now)
  end

  def undeleted!(user = User.current)
    update_attribute(get_field(user, :deleted_at), nil)
  end

  def deleted?(user = User.current)
    send(get_field(user, :deleted_at)).present?
  end

  def correspondent(user)
    sender == user ? recipient : sender
  end

  def read?(user = User.current)
    prefix = sender == user ? "sender" : "recipient"
    is_root? ? send("#{prefix}_read?") :  parent.send("#{prefix}_read?")
  end

  def get_field(user, field)
    user == sender ? :"sender_#{field}" : :"recipient_#{field}"
  end
  # class methods
  #
  class << self
    def multi_operation(user, message_ids, operation)

      case operation.to_s
      when "delete"
        user.messages.where(:id => message_ids).each do |item|
          prefix = item.sender == user ? "sender" : "recipient"
          item.update_attribute("#{prefix}_deleted_at", Time.now)
        end
      when "mark_as_unread"
        user.messages.where(:id => message_ids).each do |item|
          prefix = item.sender == user ? "sender" : "recipient"
          item.update_attribute("#{prefix}_read", false)
        end

      when "mark_as_read"
        user.messages.where(:id => message_ids).each do |item|
          prefix = item.sender == user ? "sender" : "recipient"
          item.update_attribute("#{prefix}_read", true)
        end

      when "mark_as_important"
        user.messages.where(:id => message_ids).each do |item|
          prefix = item.sender == user ? "sender" : "recipient"
          item.update_attribute("#{prefix}_marker", 'important')
        end

      end
    end

    def build_reply(message, sender, options = { })
      new(options.merge({:subject => "re: #{message.subject}",
                          :parent_id => message.id,  :sender => sender,  :recipient => message.correspondent(sender)  }) )
    end

  end # end class << self

end
