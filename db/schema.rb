# encoding: UTF-8
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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20200503073301) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "api_tokens", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "market"
    t.string   "key"
    t.string   "secret"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "balances", force: :cascade do |t|
    t.integer "user_id"
    t.string  "account"
    t.string  "coin"
    t.float   "free"
    t.float   "locked"
    t.float   "total"
    t.float   "usd_value"
    t.date    "date_at"
  end

  create_table "markets", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "base_unit"
    t.string   "quote_unit"
    t.string   "source"
    t.string   "type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "orders", force: :cascade do |t|
    t.integer  "market_id"
    t.integer  "user_id"
    t.integer  "order_id",   limit: 8
    t.string   "type"
    t.string   "pattern"
    t.float    "price"
    t.float    "amount"
    t.float    "total"
    t.datetime "created_at"
    t.integer  "cycle_id"
  end

  create_table "position_cycles", force: :cascade do |t|
    t.integer  "market_id"
    t.integer  "user_id"
    t.integer  "cycle_id"
    t.string   "title"
    t.string   "state"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "risk_coercions", force: :cascade do |t|
    t.integer "user_id"
    t.float   "daily_loss"
    t.float   "week_loss"
    t.float   "daily_ratio"
    t.float   "week_ratio"
    t.string  "notice_webhook"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "phone"
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.integer  "role",                   default: 1
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
