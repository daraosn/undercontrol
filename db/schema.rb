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

ActiveRecord::Schema.define(version: 20160310131412) do

  create_table "plans", force: :cascade do |t|
    t.string   "name"
    t.string   "stripe_id"
    t.string   "interval"
    t.integer  "amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "uc_actions", force: :cascade do |t|
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "name"
    t.string   "kind"
    t.string   "value"
    t.integer  "uc_process_id"
  end

  create_table "uc_actuators", force: :cascade do |t|
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "user_id"
    t.string   "name"
    t.string   "description"
    t.string   "kind"
  end

  create_table "uc_conditions", force: :cascade do |t|
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "name"
    t.string   "logic"
    t.integer  "uc_process_id"
  end

  create_table "uc_conditions_signals", force: :cascade do |t|
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "uc_signal_id"
    t.integer  "uc_condition_id"
  end

  create_table "uc_measurements", force: :cascade do |t|
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.decimal  "value",        precision: 12, scale: 3
    t.integer  "uc_signal_id"
  end

  add_index "uc_measurements", ["uc_signal_id"], name: "index_uc_measurements_on_uc_signal_id"

  create_table "uc_monitors", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "user_id"
    t.string   "name"
    t.string   "kind"
  end

  create_table "uc_processes", force: :cascade do |t|
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "user_id"
    t.string   "name"
    t.string   "description"
  end

  create_table "uc_sensors", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.string   "kind"
    t.integer  "user_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "uc_signals", force: :cascade do |t|
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "unit"
    t.integer  "uc_sensor_id"
    t.integer  "uc_condition_id"
  end

  add_index "uc_signals", ["uc_condition_id"], name: "index_uc_signals_on_uc_condition_id"
  add_index "uc_signals", ["uc_sensor_id"], name: "index_uc_signals_on_uc_sensor_id"

  create_table "uc_signals_monitors", force: :cascade do |t|
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "uc_signal_id"
    t.integer  "uc_monitor_id"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
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
    t.integer  "role"
    t.integer  "plan_id"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["plan_id"], name: "index_users_on_plan_id"
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
