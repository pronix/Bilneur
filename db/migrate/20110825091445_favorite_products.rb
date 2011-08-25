class FavoriteProducts < ActiveRecord::Migration
  def self.up
    create_table :favorite_variants, :id => false do |t|
      t.integer :user_id
      t.integer :variant_id
    end
    add_index :favorite_variants, :user_id
    add_index :favorite_variants, :variant_id
  end

  def self.down
    remove_index :favorite_variants, :user_id
    remove_index :favorite_variants, :variant_id
    drop_table :favorite_variants
  end
end
