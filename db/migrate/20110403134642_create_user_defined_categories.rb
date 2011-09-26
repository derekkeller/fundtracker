class CreateUserDefinedCategories < ActiveRecord::Migration
  def self.up
    create_table :user_defined_categories do |t|
      t.integer :company_id
      t.string  :name
      t.integer :c_type

      t.timestamps
    end
  end

  def self.down
    drop_table :user_defined_categories
  end
end
