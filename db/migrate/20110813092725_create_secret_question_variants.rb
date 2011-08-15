class CreateSecretQuestionVariants < ActiveRecord::Migration
  def self.up
    create_table :secret_question_variants do |t|
      t.string :variant, :null => false
      t.boolean :private, :default => false
      t.timestamps
    end
  end

  def self.down
    drop_table :secret_question_variants
  end
end
