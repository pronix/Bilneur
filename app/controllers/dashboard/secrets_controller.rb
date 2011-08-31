class Dashboard::SecretsController < Dashboard::ApplicationController
  before_filter :new_question, :only => :edit

  def edit
    @secret_question = @current_user.secret_question
  end

  def new
    @secret_question = @current_user.build_secret_question
  end

  def create

    @secret_question = @current_user.build_secret_question(params[:secret_question])
    if @secret_question.save
      redirect_to dashboard_account_path, :notice => 'Secret Question save'
    else
      render :new
    end

  end

  def update
    @secret_question  = current_user.secret_question
    if @secret_question.update_attributes(params[:secret_question])
      redirect_to dashboard_account_path, :notice => 'Secret Question updated'
    else
      render :edit
    end
  end

  private

  def new_question
    render :new and return unless @current_user.has_secret?
  end

end
