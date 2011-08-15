class CreateSellerReviews < ActiveRecord::Migration
  def self.up
    create_table :seller_reviews do |t|
      t.integer :seller_id
      t.integer :buyer_id
      t.integer :order_id
      t.text :review
      t.integer :rating

      t.timestamps
    end

    add_index :seller_reviews, :seller_id
    add_index :seller_reviews, :buyer_id
    add_index :seller_reviews, :order_id

  end

  def self.down

    remove_index :seller_reviews, :seller_id
    remove_index :seller_reviews, :buyer_id
    remove_index :seller_reviews, :order_id

    drop_table :seller_reviews
  end
end
