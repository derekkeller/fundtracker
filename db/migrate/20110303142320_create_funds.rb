class CreateFunds < ActiveRecord::Migration
  def self.up
    create_table :funds do |t|
      t.string  :name
      t.string  :number
      t.boolean :aggregate, :default => false
      t.decimal :size, :precision => 11, :scale => 2, :default => 0.00
      t.decimal :management_fee, :precision => 9, :scale => 2, :default => 0.00
      t.date    :start_date
      t.boolean :active, :default => false
      t.timestamps
    end
  end

  def self.down
    drop_table :funds
  end
end
