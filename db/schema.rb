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

ActiveRecord::Schema.define(version: 20141031022111) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "track_points", force: true do |t|
    t.integer  "track_id"
    t.float    "latitude"
    t.float    "longitude"
    t.integer  "index"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "track_points", ["track_id"], name: "index_track_points_on_track_id", using: :btree

  create_table "tracks", force: true do |t|
    t.string   "name"
    t.float    "distance"
    t.string   "time"
    t.string   "link"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "way_points", force: true do |t|
    t.integer  "track_id"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "description"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "way_points", ["track_id"], name: "index_way_points_on_track_id", using: :btree

end
