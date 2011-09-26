class CreateOperationals < ActiveRecord::Migration
  def self.up
    create_table :operationals do |t|
      t.integer :company_id
      t.date    :period_end
      t.integer :head_count
      t.integer :debt_balance, :default => 0
      t.integer :cash_balance, :default => 0
      t.integer :cash_burn, :default => 0
      t.timestamps
    end
  end

  def self.down
    drop_table :operationals
  end
end
