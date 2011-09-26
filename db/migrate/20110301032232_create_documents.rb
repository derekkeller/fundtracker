class CreateDocuments < ActiveRecord::Migration
  def self.up
    create_table :documents do |t|
      t.integer   :company_id
      t.integer   :folder_id
      t.string    :file_name
      t.string    :file_size
      t.string    :file_type
      t.string    :description
      t.string    :path
      t.integer   :created_by
      t.integer   :updated_by
      t.datetime  :created_at
      t.datetime  :updated_at
      t.string    :revision_date
      t.timestamps
    end
  end

  def self.down
    drop_table :documents
  end
end
