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

ActiveRecord::Schema.define(version: 20151215215106) do

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

  create_table "patent_indices", force: :cascade do |t|
    t.integer  "stage_of_research_index_id"
    t.integer  "patent_status_index_id"
    t.integer  "institution_id"
    t.string   "title"
    t.integer  "ref"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.integer  "patent_raw_id"
    t.string   "patent_id",                  null: false
    t.string   "keywords"
    t.string   "inventors"
  end

  add_index "patent_indices", ["institution_id"], name: "index_patent_indices_on_institution_id", using: :btree
  add_index "patent_indices", ["keywords"], name: "index_patent_indices_on_keywords", using: :btree
  add_index "patent_indices", ["patent_id"], name: "index_patent_indices_on_patent_id", unique: true, using: :btree
  add_index "patent_indices", ["patent_raw_id"], name: "index_patent_indices_on_patent_raw_id", using: :btree
  add_index "patent_indices", ["patent_status_index_id"], name: "index_patent_indices_on_patent_status_index_id", using: :btree
  add_index "patent_indices", ["ref", "institution_id"], name: "index_patent_indices_on_ref_and_institution_id", using: :btree
  add_index "patent_indices", ["stage_of_research_index_id"], name: "index_patent_indices_on_stage_of_research_index_id", using: :btree

  create_table "patent_raws", force: :cascade do |t|
    t.json     "raw_data"
    t.integer  "patent_entry_id"
    t.string   "state",           null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "institution_id"
  end

  add_index "patent_raws", ["institution_id"], name: "index_patent_raws_on_institution_id", using: :btree
  add_index "patent_raws", ["patent_entry_id"], name: "index_patent_raws_on_patent_entry_id", using: :btree
  add_index "patent_raws", ["patent_entry_id"], name: "one_per_patent", unique: true, using: :btree

  create_table "patent_status_indices", force: :cascade do |t|
    t.string   "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "patent_status_indices", ["status"], name: "index_patent_status_indices_on_status", unique: true, using: :btree

  create_table "stage_of_research_indices", force: :cascade do |t|
    t.string   "stage",      null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "stage_of_research_indices", ["stage"], name: "index_stage_of_research_indices_on_stage", unique: true, using: :btree

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree

  create_table "tags", force: :cascade do |t|
    t.string  "name"
    t.integer "taggings_count", default: 0
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

  add_foreign_key "patent_entries", "institutions"
  add_foreign_key "patent_indices", "institutions"
  add_foreign_key "patent_indices", "patent_raws"
  add_foreign_key "patent_indices", "patent_status_indices"
  add_foreign_key "patent_indices", "stage_of_research_indices"
  add_foreign_key "patent_raws", "institutions"
  add_foreign_key "patent_raws", "patent_entries"
end
