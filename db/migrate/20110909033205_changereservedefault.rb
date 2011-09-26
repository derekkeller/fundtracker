class Changereservedefault < ActiveRecord::Migration
  def self.up
    change_column_default :companies, :reserves, 0
    add_column :funds, :comments, :text
  end

  def self.down
    remove_column :funds, :comments
  end
end