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

ActiveRecord::Schema.define(version: 20150419192102) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "diagnoses", force: true do |t|
    t.string   "code"
    t.text     "description"
    t.integer  "diagnosis_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.tsvector "search_vector"
  end

  add_index "diagnoses", ["code"], name: "index_diagnoses_on_code", unique: true, using: :btree
  add_index "diagnoses", ["diagnosis_id"], name: "index_diagnoses_on_diagnosis_id", using: :btree
  add_index "diagnoses", ["search_vector"], name: "diagnoses_search_idx", using: :gin

end