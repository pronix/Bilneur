class CreateMessages < ActiveRecord::Migration
  def self.up
    create_table :messages do |t|
      t.integer  :sender_id
      t.integer  :recipient_id
      t.string   :ancestry

      t.boolean  :sender_read,              :default => true
      t.boolean  :recipient_read,           :default => false
      t.string   :sender_marker
      t.string   :recipient_marker
      t.string   :subject
      t.text     :content
      t.datetime :sender_deleted_at
      t.datetime :recipient_deleted_at

      t.timestamps
    end

    add_index :messages, :recipient_id
    add_index :messages, :sender_id
    add_index :messages, :ancestry

  end

  def self.down
    remove_index :messages, :recipient_id
    remove_index :messages, :sender_id
    remove_index :messages, :ancestry
    drop_table :messages

  end
end
