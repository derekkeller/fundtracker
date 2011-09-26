class CreatePeriodResults < ActiveRecord::Migration
  def self.up
    create_table :period_results do |t|
      t.integer :company_id
      t.integer :bookings, :default => 0
      t.integer :revenue, :default => 0
      t.integer :cogs, :default => 0
      t.integer :operating_expenses
      t.integer :sg_and_a, :default => 0
      t.integer :r_and_d, :default => 0
      t.integer :depreciation, :default => 0
      t.integer :amortization, :default => 0
      t.integer :interest_income, :default => 0
      t.integer :interest_expense, :default => 0
      t.integer :other_income, :default => 0
      t.integer :other_expense, :default => 0
      t.integer :tax_expense, :default => 0
      t.timestamps
    end
  end

  def self.down
    drop_table :period_results
  end
end
