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

ActiveRecord::Schema.define(version: 20160312115503) do

  create_table "measurements", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "value",      precision: 12, scale: 3
    t.integer  "thing_id"
  end

  add_index "measurements", ["thing_id"], name: "index_measurements_on_thing_id"

  create_table "plans", force: :cascade do |t|
    t.string   "name"
    t.string   "stripe_id"
    t.string   "interval"
    t.integer  "amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "things", force: :cascade do |t|
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.integer  "user_id",                         null: false
    t.string   "api_key"
    t.string   "name"
    t.string   "description"
    t.decimal  "range_min"
    t.decimal  "range_max"
    t.string   "alarm_action"
    t.decimal  "alarm_max"
    t.decimal  "alarm_min"
    t.integer  "alarm_threshold"
    t.boolean  "alarm_triggered", default: false
  end

  add_index "things", ["user_id"], name: "index_things_on_user_id"

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "username",               default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "name"
    t.integer  "role"
    t.integer  "plan_id"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["plan_id"], name: "index_users_on_plan_id"
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
