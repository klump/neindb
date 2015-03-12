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

ActiveRecord::Schema.define(version: 20150312214100) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "assets", force: :cascade do |t|
    t.string   "name"
    t.string   "type"
    t.json     "properties"
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
    t.json     "properties"
    t.string   "type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "reports", force: :cascade do |t|
    t.string   "status"
    t.datetime "starttime"
    t.datetime "endtime"
    t.text     "log"
    t.json     "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "asset_id"
  end

  create_table "revisions", force: :cascade do |t|
    t.json     "old_data"
    t.json     "new_data"
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

  add_foreign_key "attached_components", "assets", on_delete: :cascade
  add_foreign_key "attached_components", "components", on_delete: :cascade
  add_foreign_key "reports", "assets", on_delete: :cascade
  add_foreign_key "statuses", "assets", on_delete: :cascade
end
