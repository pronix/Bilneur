class SecretQuestionVariant < ActiveRecord::Base
  has_one :secret_question

  validates :variant, :presence => true

  # Return only public variants
  scope :public, where(:private => false)
  # Return only public variants with user own private variant
  scope :public_with, lambda { |own_question| where("private is false OR id = :own", { :own => own_question }) }
end
