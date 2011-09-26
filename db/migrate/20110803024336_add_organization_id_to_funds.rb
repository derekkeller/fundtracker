class AddOrganizationIdToFunds < ActiveRecord::Migration
  def self.up
    add_column :funds, :organization_id, :integer
  end

  def self.down
    remove_column :funds, :organization_id
  end
end
