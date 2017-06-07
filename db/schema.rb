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

ActiveRecord::Schema.define(version: 20170606195237) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "comments", force: true do |t|
    t.integer  "user_id"
    t.integer  "track_id"
    t.text     "text"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["track_id"], name: "index_comments_on_track_id", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "settings", force: true do |t|
    t.string   "var",         null: false
    t.text     "value"
    t.integer  "target_id",   null: false
    t.string   "target_type", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "settings", ["target_type", "target_id", "var"], name: "index_settings_on_target_type_and_target_id_and_var", unique: true, using: :btree

  create_table "start_times", force: true do |t|
    t.integer  "day_of_week"
    t.time     "time"
    t.integer  "track_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "date"
    t.boolean  "is_repeated"
    t.integer  "every",       default: 1
  end

  add_index "start_times", ["track_id"], name: "index_start_times_on_track_id", using: :btree

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
    t.integer  "color_index"
    t.integer  "user_id"
    t.string   "category"
    t.text     "description", default: ""
  end

  add_index "tracks", ["user_id"], name: "index_tracks_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "admin",                  default: false, null: false
    t.string   "name",                   default: "",    null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "way_points", force: true do |t|
    t.integer  "track_id"
    t.float    "latitude",                null: false
    t.float    "longitude",               null: false
    t.string   "description"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "time",        default: 0
  end

  add_index "way_points", ["id", "type"], name: "index_way_points_on_id_and_type", using: :btree
  add_index "way_points", ["track_id"], name: "index_way_points_on_track_id", using: :btree

end
