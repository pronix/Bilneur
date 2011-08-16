class PasswordByQuestionController < ApplicationController
  before_filter :check_email, :validate_response, :only => :reset_by_question

  def reset_by_question
  end

  def new_password
    User.find(session[:user_id]).update_attributes(params[:user])
    flash.notice = "Password is reset, please log in"
    redirect_to new_user_session_path
  end

  private

  # For flash error and redirect to new user password page
  def some_error(error='Some thing wrong')
    flash.notice = error
    redirect_to new_user_password_path and return
  end

  # First check it's email. We don't can check user after question and answer
  # Becouse maybe 2 same question and 2 same answer
  def check_email
    some_error('Sorry but wrong email address') if !@user = User.find_by_email(params[:email])
  end

  def validate_response
    if params[:own_question].blank?
      some_error('Sorry but incorect question or answer') if !@user.check_valid_user_with_regular_question(params)
    end
    # Create session for recovery password
    session[:user_id] = @user.id
  end

end
