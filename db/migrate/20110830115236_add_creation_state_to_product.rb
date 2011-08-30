class AddCreationStateToProduct < ActiveRecord::Migration
  def self.up
    add_column :products, :creation_state, :string
  end

  def self.down
    remove_column :products, :creation_state
  end
end
