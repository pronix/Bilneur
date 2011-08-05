class AddTermsAndConditionsToSeller < ActiveRecord::Migration
  def self.up
    add_column :users, :terms, :text
  end

  def self.down
    remove_column :users, :terms
  end
end
