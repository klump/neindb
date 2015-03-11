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

ActiveRecord::Schema.define(version: 20150311221835) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "attached_components", force: :cascade do |t|
    t.string   "connector"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "computer_id"
    t.integer  "component_id"
  end

  create_table "cages", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "checks", force: :cascade do |t|
    t.string   "name"
    t.string   "status"
    t.string   "message"
    t.text     "data"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "computer_id"
  end

  create_table "components", force: :cascade do |t|
    t.string   "type"
    t.hstore   "properties"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "computers", force: :cascade do |t|
    t.string   "serial"
    t.string   "location"
    t.integer  "dimm_slots"
    t.integer  "pci_slots"
    t.string   "bios_vendor"
    t.string   "bios_version"
    t.string   "vendor"
    t.string   "product_name"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "hard_drives", force: :cascade do |t|
    t.string   "serial"
    t.string   "model"
    t.string   "device_model"
    t.string   "firmware"
    t.integer  "capacity_bytes",             limit: 8
    t.integer  "rpm"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.integer  "hard_drive_attachable_id"
    t.string   "hard_drive_attachable_type"
  end

  create_table "information", force: :cascade do |t|
    t.string   "name"
    t.text     "data"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "computer_id"
  end

  create_table "reports", force: :cascade do |t|
    t.string   "status"
    t.datetime "starttime"
    t.datetime "endtime"
    t.text     "log"
    t.json     "data"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "computer_id"
  end

  add_foreign_key "attached_components", "components", on_delete: :cascade
  add_foreign_key "attached_components", "computers", on_delete: :cascade
  add_foreign_key "checks", "computers", on_delete: :cascade
  add_foreign_key "information", "computers", on_delete: :cascade
  add_foreign_key "reports", "computers", on_delete: :cascade
end
