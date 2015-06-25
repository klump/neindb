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

ActiveRecord::Schema.define(version: 20150430150036) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "assets", force: :cascade do |t|
    t.string   "name"
    t.string   "type"
    t.jsonb    "properties", null: false, default: '{}'
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "attached_components", force: :cascade do |t|
    t.string   "connector"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "asset_id"
    t.integer  "component_id"
  end

  create_table "components", force: :cascade do |t|
    t.string   "name"
    t.string   "vendor"
    t.jsonb    "properties", null: false, default: '{}'
    t.string   "type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "reports", force: :cascade do |t|
    t.string   "status"
    t.datetime "starttime"
    t.datetime "endtime"
    t.jsonb    "data",          null: false, default: '{}'
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "asset_id"
    t.integer  "user_id",       null: false
    t.string   "parser_status"
  end

  create_table "revisions", force: :cascade do |t|
    t.jsonb    "data",              null: false, default: '{}'
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.integer  "revisionable_id",   null: false
    t.string   "revisionable_type", null: false
    t.integer  "trigger_id",        null: false
    t.string   "trigger_type",      null: false
  end

  create_table "statuses", force: :cascade do |t|
    t.string   "name"
    t.string   "state"
    t.string   "message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "asset_id",   null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "name",               default: "", null: false
    t.string   "username",           default: "", null: false
    t.string   "role",               default: "", null: false
    t.string   "auth_token",         default: "", null: false
    t.string   "email",              default: "", null: false
    t.string   "encrypted_password", default: "", null: false
    t.integer  "sign_in_count",      default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["auth_token"], name: "index_users_on_auth_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["name"], name: "index_users_on_name", unique: true, using: :btree

  add_foreign_key "attached_components", "assets", on_delete: :cascade
  add_foreign_key "attached_components", "components", on_delete: :cascade
  add_foreign_key "reports", "assets", on_delete: :cascade
  add_foreign_key "statuses", "assets", on_delete: :cascade
end
