class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.integer :company_id
      t.string :email
      t.string :first_name
      t.string :last_name
      t.string :password_hash
      t.integer :fund_id
      t.integer :role_id
      t.boolean :active, :default => false
      t.boolean :is_admin, :default => false
      t.datetime :last_login
      t.string :password_recovery_hash
      t.datetime :recovery_hash_created_at
      t.timestamps
    end
    
    add_index :users, :email, :unique => true
    
    a = User.create(:email => "derek@highway12ventures.com", :first_name => 'Derek', :password => 'secrets!', :last_name => 'Keller')
    a.active = true
    a.is_admin = true
    a.save!
    
    b = User.create(:email => "justinbkay@gmail.com", :first_name => 'Justin', :password => 'secrets!', :last_name => 'Kay')
    b.active = true
    b.is_admin = true
    b.save!
  end

  def self.down
    drop_table :users
  end
end
