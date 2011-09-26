class AddForecastId < ActiveRecord::Migration
  def self.up
    add_column :custom_cells, :forecast_id, :integer
  end

  def self.down
    remove_column :custom_cells, :forecast_id
  end
end