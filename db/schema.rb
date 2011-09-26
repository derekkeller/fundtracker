# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110909033205) do

  create_table "companies", :force => true do |t|
    t.integer  "fund_id"
    t.string   "name"
    t.date     "founded"
    t.integer  "industry_id"
    t.text     "description"
    t.integer  "reserves",                                   :default => 0
    t.text     "syndicate"
    t.integer  "status_id"
    t.date     "status_date"
    t.decimal  "exit_amount", :precision => 11, :scale => 2, :default => 0.0
    t.decimal  "fund_return", :precision => 11, :scale => 2, :default => 0.0
    t.text     "notes"
    t.boolean  "active",                                     :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "custom_cells", :force => true do |t|
    t.integer  "period_result_id"
    t.integer  "user_defined_category_id"
    t.integer  "amount",                   :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "forecast_id"
  end

  create_table "documents", :force => true do |t|
    t.integer  "company_id"
    t.integer  "folder_id"
    t.string   "file_name"
    t.string   "file_size"
    t.string   "file_type"
    t.string   "description"
    t.string   "path"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "revision_date"
  end

  create_table "folders", :force => true do |t|
    t.integer  "company_id"
    t.string   "name"
    t.boolean  "active",     :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "forecasts", :force => true do |t|
    t.integer  "company_id"
    t.integer  "bookings",           :default => 0
    t.integer  "revenue",            :default => 0
    t.integer  "cogs",               :default => 0
    t.integer  "operating_expenses", :default => 0
    t.integer  "sg_and_a",           :default => 0
    t.integer  "r_and_d",            :default => 0
    t.integer  "depreciation",       :default => 0
    t.integer  "amortization",       :default => 0
    t.integer  "interest_income",    :default => 0
    t.integer  "interest_expense",   :default => 0
    t.integer  "other_income",       :default => 0
    t.integer  "other_expense",      :default => 0
    t.integer  "tax_expense",        :default => 0
    t.date     "period"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "funds", :force => true do |t|
    t.string   "name"
    t.string   "number"
    t.boolean  "aggregate",       :default => false
    t.integer  "size",            :default => 0
    t.integer  "management_fee",  :default => 0
    t.date     "start_date"
    t.boolean  "active",          :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "organization_id"
    t.text     "comments"
  end

  create_table "operationals", :force => true do |t|
    t.integer  "company_id"
    t.date     "period_end"
    t.integer  "head_count"
    t.integer  "debt_balance", :default => 0
    t.integer  "cash_balance", :default => 0
    t.integer  "cash_burn",    :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "organizations", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "period_results", :force => true do |t|
    t.integer  "company_id"
    t.integer  "bookings",           :default => 0
    t.integer  "revenue",            :default => 0
    t.integer  "cogs",               :default => 0
    t.integer  "operating_expenses"
    t.integer  "sg_and_a",           :default => 0
    t.integer  "r_and_d",            :default => 0
    t.integer  "depreciation",       :default => 0
    t.integer  "amortization",       :default => 0
    t.integer  "interest_income",    :default => 0
    t.integer  "interest_expense",   :default => 0
    t.integer  "other_income",       :default => 0
    t.integer  "other_expense",      :default => 0
    t.integer  "tax_expense",        :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "period"
  end

  create_table "series", :force => true do |t|
    t.integer  "company_id"
    t.string   "name"
    t.decimal  "existing_capital_raised",    :precision => 11, :scale => 2, :default => 0.0
    t.date     "date"
    t.decimal  "pre_money",                  :precision => 11, :scale => 2, :default => 0.0
    t.decimal  "capital_raised",             :precision => 11, :scale => 2, :default => 0.0
    t.decimal  "post_money",                 :precision => 11, :scale => 2, :default => 0.0
    t.string   "security_type"
    t.decimal  "share_price",                :precision => 6,  :scale => 2, :default => 0.0
    t.decimal  "liquidation_preference",     :precision => 6,  :scale => 2, :default => 0.0
    t.decimal  "liquidation_preference_cap", :precision => 6,  :scale => 2, :default => 0.0
    t.decimal  "dividends",                  :precision => 5,  :scale => 2, :default => 0.0
    t.integer  "dividends_period"
    t.integer  "shares_purchased"
    t.decimal  "preferred_ownership",        :precision => 5,  :scale => 2, :default => 0.0
    t.decimal  "fully_diluted_ownership",    :precision => 5,  :scale => 2, :default => 0.0
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "investment",                 :precision => 11, :scale => 2, :default => 0.0
  end

  create_table "user_defined_categories", :force => true do |t|
    t.integer  "company_id"
    t.string   "name"
    t.integer  "c_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "sign"
  end

  create_table "users", :force => true do |t|
    t.integer  "company_id"
    t.string   "email"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "password_hash"
    t.integer  "fund_id"
    t.integer  "role_id"
    t.boolean  "active",                   :default => false
    t.boolean  "is_admin",                 :default => false
    t.datetime "last_login"
    t.string   "password_recovery_hash"
    t.datetime "recovery_hash_created_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true

end
