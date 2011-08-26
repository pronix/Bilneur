class CreateFavoriteSellers < ActiveRecord::Migration
  def self.up
    create_table :favorite_sellers, :id => false do |t|
      t.integer :user_id
      t.integer :seller_id
    end
  end

  def self.down
    drop_table :favorite_sellers
  end
end
