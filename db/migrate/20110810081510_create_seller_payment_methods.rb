class CreateSellerPaymentMethods < ActiveRecord::Migration
  def self.up
    create_table :seller_payment_methods do |t|
      t.string  :type,    :null => false
      t.integer :user_id, :null => false
      t.string  :name
      t.text    :description
      t.string  :state
      t.timestamps
    end

    add_index :seller_payment_methods, :user_id
  end

  def self.down
    remove_index :seller_payment_methods, :user_id
    drop_table :seller_payment_methods
  end
end
