class CreateStaticData < ActiveRecord::Migration
  def self.up
    create_table :static_data do |t|
      t.text :about, :faq, :term, :return_policy
      t.integer :user_id, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :static_data
  end
end
