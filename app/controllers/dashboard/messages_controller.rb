class Dashboard::MessagesController < Dashboard::ApplicationController

  def index
    @state = params[:state] ? params[:state].to_s.titleize  : "All Messages"
    @messages =
      case params[:state].to_s
      when "received"  then current_user.inbox.roots.undeleted
      when "sent"      then current_user.sent.roots.undeleted
      when "unread"    then current_user.messages.roots.undeleted.unread
      when "important" then current_user.messages.roots.undeleted.important
      when "trash"     then current_user.messages.roots.trash
      else
        current_user.messages.roots.undeleted
      end.paginate(:per_page => (params[:per_page]||10), :page => params[:page])
  end

  def show
    @message = current_user.messages.roots.find(params[:id])
    @children_messages = @message.children.order("created_at")
  end

  def new
    @recipient = User.find(params[:user_id])
    @message = Message.new
  end

  def create
    @recipient = User.find(params[:user_id])
    @message = Message.new(params[:message].merge({
                                                    :recipient => @recipient,
                                                    :sender => current_user }))

    if @message.save
      redirect_to dashboard_messages_path, :notice => "Your message sent."
    else
      render :new
    end

  end

  def reply
    @message = current_user.messages.roots.find(params[:id])
    @reply_message = Message.build_reply(@message, current_user, params[:message])
    if @reply_message.save
      redirect_to dashboard_message_path(@message), :notice => "Reply send"
    else
      @children_messages = @message.children.order("created_at")
      render :show
    end

  end

  def multi
    if params[:message_ids].present? && %w(delete mark_as_unread mark_as_read mark_as_important).include?(params[:multi].to_s)
     Message.multi_operation(current_user, params[:message_ids], params[:multi])
   end
    redirect_to dashboard_messages_path
  end

  def destroy
    @message = current_user.messages.roots.find(params[:id])
    @message.deleted!
    redirect_to dashboard_messages_path
  end

end
