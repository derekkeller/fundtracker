class Alterfunds < ActiveRecord::Migration
  def self.up
    change_column :funds, :size, :integer
    change_column :funds, :management_fee, :integer
  end

  def self.down

  end
end