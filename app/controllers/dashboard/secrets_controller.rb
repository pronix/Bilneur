class Dashboard::SecretsController < Dashboard::ApplicationController
  before_filter :new_question, :only => :edit

  def edit
    @secret_question = @current_user.secret_question
  end

  def new
    @secret_question = @current_user.build_secret_question
  end

  def create
    unless params[:own_question].blank?
      variant = @current_user.secret_question.create_secret_question_variant(:variant => params[:own_question], :private => true)
      @current_user.create_secret_question(:answer => params[:secret_question][:answer], :secret_question_variant => variant)
    else
      @current_user.create_secret_question(params[:secret_question])
    end
    flash.notice = 'Secret Question save'
    redirect_to dashboard_account_path
  end

  def update
    unless params[:own_question].blank?
      variant = @current_user.secret_question.create_secret_question_variant(:variant => params[:own_question], :private => true)
      @current_user.secret_question.update_attributes(:answer => params[:secret_question][:answer], :secret_question_variant => variant)
    else
      @current_user.secret_question.update_attributes(params[:secret_question])
    end
    redirect_to dashboard_account_path
  end

  private

  def new_question
    render :new and return unless @current_user.has_secret?
  end
end
