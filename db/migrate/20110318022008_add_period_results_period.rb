class AddPeriodResultsPeriod < ActiveRecord::Migration
  def self.up
    add_column :period_results, :period, :date
  end

  def self.down
    remove_column :period_results, :period
  end
end