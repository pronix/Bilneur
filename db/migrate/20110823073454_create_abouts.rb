class CreateAbouts < ActiveRecord::Migration
  def self.up
    create_table :abouts do |t|
      t.text :you, :faq, :term
      t.integer :user_id, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :abouts
  end
end
