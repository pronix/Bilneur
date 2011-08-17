class CreateSecretQuestions < ActiveRecord::Migration
  def self.up
    create_table :secret_questions do |t|
      t.integer :user_id, :secret_question_variant_id, :null => false
      t.string :answer
      t.timestamps
    end
  end

  def self.down
    drop_table :secret_questions
  end
end
