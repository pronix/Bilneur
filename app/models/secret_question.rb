class SecretQuestion < ActiveRecord::Base
  belongs_to :user
  belongs_to :secret_question_variant
end
