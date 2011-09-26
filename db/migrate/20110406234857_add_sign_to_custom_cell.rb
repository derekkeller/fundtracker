class AddSignToCustomCell < ActiveRecord::Migration
  def self.up
    add_column :user_defined_categories, :sign, :integer
  end

  def self.down
    remove_column :user_defined_categories, :sign
  end
end