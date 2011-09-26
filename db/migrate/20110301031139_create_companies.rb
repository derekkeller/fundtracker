class CreateCompanies < ActiveRecord::Migration
  def self.up
    create_table :companies do |t|
      t.integer :fund_id
      t.string  :name
      t.date    :founded
      t.integer :industry_id
      t.text    :description
      t.integer :reserves
      t.text    :syndicate
      t.integer :status_id
      t.date    :status_date
      t.decimal :exit_amount, :precision => 11, :scale => 2, :default => 0.00
      t.decimal :fund_return, :precision => 11, :scale => 2, :default => 0.00
      t.text    :notes
      t.boolean :active, :default => false
      t.timestamps
    end
  end

  def self.down
    drop_table :companies
  end
end
