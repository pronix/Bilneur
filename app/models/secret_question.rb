class SecretQuestion < ActiveRecord::Base
  attr_accessor :own_question

  belongs_to :user
  belongs_to :secret_question_variant


  validates :answer, :presence => true

  validates :secret_question_variant_id, :presence => true

  validates :own_question, :presence => true, :if => lambda{ |t| t.secret_question_variant_id.to_i == -1  }

  def own_question=(v)
    unless v.blank?
      @own_question = v
      build_secret_question_variant(:variant => v, :private => true)
    end
  end

end
