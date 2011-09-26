class CreateFolders < ActiveRecord::Migration
  def self.up
    create_table :folders do |t|
      t.integer   :company_id
      t.string    :name
      t.boolean   :active, :default => false
      t.timestamps
    end
  end

  def self.down
    drop_table :folders
  end
end
