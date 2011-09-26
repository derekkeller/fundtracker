class CreateCustomCells < ActiveRecord::Migration
  def self.up
    create_table :custom_cells do |t|
      t.integer :period_result_id
      t.integer :user_defined_category_id
      t.integer :amount, :default => 0

      t.timestamps
    end
  end

  def self.down
    drop_table :custom_cells
  end
end
