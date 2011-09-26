class Test < ActiveRecord::Migration
  def self.up
    add_column :series, :investment, :decimal, :precision => 11, :scale => 2, :default => 0.0
  end

  def self.down
    remove_column :series, :investment
  end
end