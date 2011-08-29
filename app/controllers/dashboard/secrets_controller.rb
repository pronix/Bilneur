class Dashboard::SecretsController < Dashboard::ApplicationController
  before_filter :new_question, :only => :edit
  before_filter :validate_question, :only => [:create, :update]

  def edit
    @secret_question = @current_user.secret_question
  end

  def new
    @secret_question = @current_user.build_secret_question
  end

  def create

    unless params[:own_question].blank?
      variant = SecretQuestionVariant.create(:variant => params[:own_question], :private => true)
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
      @current_user.secret_question.update_attributes(:answer => params[:secret_question][:answer],
                                                      :secret_question_variant => variant)
    else
      @current_user.secret_question.update_attributes(params[:secret_question])
    end
    flash.notice = 'Secret Question updated'
    redirect_to dashboard_account_path
  end

  private

  def new_question
    render :new and return unless @current_user.has_secret?
  end

  def validate_question
    # FIXME It's bad all validation should be in the model
    # When user don't fill anything
    some_error('Please check a question') if params[:own_question].blank? &&
                                             params[:secret_question][:secret_question_variant_id].blank?
    # When user don't fill answer
    some_error('Please write you answer') if params[:secret_question][:answer].blank?
    # When user check own qustion but don't write his
    some_error('Please check a question') if params[:own_question].blank? &&
                                             params[:secret_question][:secret_question_variant_id].to_i == 5
  end

  def some_error(error='some thing wrong')
    flash.notice = error
    redirect_to edit_dashboard_secrets_path and return
  end

end
