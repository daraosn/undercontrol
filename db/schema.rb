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

ActiveRecord::Schema.define(version: 20160312115442) do

  create_table "measurements", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "thing_id",   limit: 4
    t.decimal  "value",                precision: 12, scale: 3
  end

  add_index "measurements", ["thing_id"], name: "index_measurements_on_thing_id", using: :btree

  create_table "payola_affiliates", force: :cascade do |t|
    t.string   "code",       limit: 255
    t.string   "email",      limit: 255
    t.integer  "percent",    limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "payola_coupons", force: :cascade do |t|
    t.string   "code",        limit: 255
    t.integer  "percent_off", limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "active",                  default: true
  end

  create_table "payola_sales", force: :cascade do |t|
    t.string   "email",                limit: 191
    t.string   "guid",                 limit: 191
    t.integer  "product_id",           limit: 4
    t.string   "product_type",         limit: 100
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "state",                limit: 255
    t.string   "stripe_id",            limit: 255
    t.string   "stripe_token",         limit: 255
    t.string   "card_last4",           limit: 255
    t.date     "card_expiration"
    t.string   "card_type",            limit: 255
    t.text     "error",                limit: 65535
    t.integer  "amount",               limit: 4
    t.integer  "fee_amount",           limit: 4
    t.integer  "coupon_id",            limit: 4
    t.boolean  "opt_in"
    t.integer  "download_count",       limit: 4
    t.integer  "affiliate_id",         limit: 4
    t.text     "customer_address",     limit: 65535
    t.text     "business_address",     limit: 65535
    t.string   "stripe_customer_id",   limit: 191
    t.string   "currency",             limit: 255
    t.text     "signed_custom_fields", limit: 65535
    t.integer  "owner_id",             limit: 4
    t.string   "owner_type",           limit: 100
  end

  add_index "payola_sales", ["coupon_id"], name: "index_payola_sales_on_coupon_id", using: :btree
  add_index "payola_sales", ["email"], name: "index_payola_sales_on_email", using: :btree
  add_index "payola_sales", ["guid"], name: "index_payola_sales_on_guid", using: :btree
  add_index "payola_sales", ["owner_id", "owner_type"], name: "index_payola_sales_on_owner_id_and_owner_type", using: :btree
  add_index "payola_sales", ["product_id", "product_type"], name: "index_payola_sales_on_product", using: :btree
  add_index "payola_sales", ["stripe_customer_id"], name: "index_payola_sales_on_stripe_customer_id", using: :btree

  create_table "payola_stripe_webhooks", force: :cascade do |t|
    t.string   "stripe_id",  limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "payola_subscriptions", force: :cascade do |t|
    t.string   "plan_type",            limit: 255
    t.integer  "plan_id",              limit: 4
    t.datetime "start"
    t.string   "status",               limit: 255
    t.string   "owner_type",           limit: 255
    t.integer  "owner_id",             limit: 4
    t.string   "stripe_customer_id",   limit: 255
    t.boolean  "cancel_at_period_end"
    t.datetime "current_period_start"
    t.datetime "current_period_end"
    t.datetime "ended_at"
    t.datetime "trial_start"
    t.datetime "trial_end"
    t.datetime "canceled_at"
    t.integer  "quantity",             limit: 4
    t.string   "stripe_id",            limit: 255
    t.string   "stripe_token",         limit: 255
    t.string   "card_last4",           limit: 255
    t.date     "card_expiration"
    t.string   "card_type",            limit: 255
    t.text     "error",                limit: 65535
    t.string   "state",                limit: 255
    t.string   "email",                limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "currency",             limit: 255
    t.integer  "amount",               limit: 4
    t.string   "guid",                 limit: 191
    t.string   "stripe_status",        limit: 255
    t.integer  "affiliate_id",         limit: 4
    t.string   "coupon",               limit: 255
    t.text     "signed_custom_fields", limit: 65535
    t.text     "customer_address",     limit: 65535
    t.text     "business_address",     limit: 65535
    t.integer  "setup_fee",            limit: 4
    t.integer  "tax_percent",          limit: 4
  end

  add_index "payola_subscriptions", ["guid"], name: "index_payola_subscriptions_on_guid", using: :btree

  create_table "plans", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "stripe_id",  limit: 255
    t.string   "interval",   limit: 255
    t.integer  "amount",     limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "things", force: :cascade do |t|
    t.datetime "created_at",                                                            null: false
    t.datetime "updated_at",                                                            null: false
    t.integer  "user_id",         limit: 4,                                             null: false
    t.string   "api_key",         limit: 255
    t.string   "name",            limit: 255
    t.string   "description",     limit: 255
    t.decimal  "range_min",                    precision: 12, scale: 3, default: 0.0
    t.decimal  "range_max",                    precision: 12, scale: 3, default: 100.0
    t.string   "alarm_action",    limit: 8192
    t.decimal  "alarm_max",                    precision: 12, scale: 3, default: 0.0
    t.decimal  "alarm_min",                    precision: 12, scale: 3, default: 0.0
    t.integer  "alarm_threshold", limit: 4,                             default: 0
    t.boolean  "alarm_triggered",                                       default: false
  end

  add_index "things", ["user_id"], name: "index_things_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "username",               limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.string   "confirmation_token",     limit: 255
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email",      limit: 255
    t.integer  "failed_attempts",        limit: 4,   default: 0,  null: false
    t.string   "unlock_token",           limit: 255
    t.datetime "locked_at"
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.string   "name",                   limit: 255
    t.integer  "role",                   limit: 4
    t.integer  "plan_id",                limit: 4
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["plan_id"], name: "index_users_on_plan_id", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["unlock_token"], name: "index_users_on_unlock_token", unique: true, using: :btree

  add_foreign_key "users", "plans"
end
