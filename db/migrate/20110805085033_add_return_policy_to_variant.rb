class AddReturnPolicyToVariant < ActiveRecord::Migration

  def self.up
    add_column :variants, :return_policy, :boolean, :default => false
    add_column :variants, :return_policy_description, :text
  end

  def self.down
    remove_column :variants, :return_policy_description
    remove_column :variants, :return_policy
  end

end
