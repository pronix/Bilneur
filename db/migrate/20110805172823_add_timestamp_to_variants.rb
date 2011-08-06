class AddTimestampToVariants < ActiveRecord::Migration
  def self.up
    add_column :variants, :created_at, :datetime
    add_column :variants, :updated_at, :datetime
    Variant.all.map{ |v| v.update_attributes({ :created_at => Time.now})}
  end

  def self.down
    remove_column :variants, :created_at
    remove_column :variants, :updated_at

  end
end
