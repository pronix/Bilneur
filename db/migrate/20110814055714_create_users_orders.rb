class CreateUsersOrders < ActiveRecord::Migration
  def self.up
    create_table :orders_users, :id => false do |t|
      t.references :user
      t.references :order
    end
    add_index :orders_users, :order_id
    add_index :orders_users, :user_id
  end

  def self.down
    remove_index :orders_users, :order_id
    remove_index :orders_users, :user_id
    drop_table :orders_users
  end
end
