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

ActiveRecord::Schema.define(version: 20151214230044) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "institutions", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "patent_data", force: :cascade do |t|
    t.json     "datum"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "patent_entries", force: :cascade do |t|
    t.integer  "institution_id"
    t.integer  "ref"
    t.string   "state",          null: false
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "patent_entries", ["institution_id"], name: "index_patent_entries_on_institution_id", using: :btree
  add_index "patent_entries", ["ref", "institution_id"], name: "index_patent_entries_on_ref_and_institution_id", unique: true, using: :btree

  add_foreign_key "patent_entries", "institutions"
end
