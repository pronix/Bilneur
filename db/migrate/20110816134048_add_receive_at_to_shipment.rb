class AddReceiveAtToShipment < ActiveRecord::Migration
  def self.up
    add_column :shipments, :receive_at, :datetime
  end

  def self.down
    remove_column :shipments, :receive_at
  end
end
