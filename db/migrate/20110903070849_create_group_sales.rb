class CreateGroupSales < ActiveRecord::Migration
  def self.up
    create_table :group_sales do |t|
      t.integer  :seller_id, :null => false
      t.integer  :variant_id, :null => false
      t.integer  :product_id, :null => false
      t.datetime :start_selling
      t.datetime :stop_selling
      t.integer  :count,         :null => false
      t.decimal  :price,         :precision => 8, :scale => 2, :null => false
      t.decimal  :retail_price,  :precision => 8, :scale => 2
      t.string   :name,          :null => false
      t.text     :description
      t.text     :features

      t.boolean  :active,       :default => true

      t.timestamps
    end

    add_index :group_sales, :seller_id
    add_index :group_sales, :variant_id
    add_index :group_sales, :product_id

    add_index :group_sales, :active
    add_index :group_sales, :start_selling
    add_index :group_sales, :stop_selling


  end

  def self.down
    remove_index :group_sales, :seller_id
    remove_index :group_sales, :variant_id
    remove_index :group_sales, :product_id
    remove_index :group_sales, :active
    remove_index :group_sales, :start_selling
    remove_index :group_sales, :stop_selling


    drop_table :group_sales

  end
end
