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

ActiveRecord::Schema.define(version: 20140329181829) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "stations", force: true do |t|
    t.integer  "babs_id"
    t.string   "name"
    t.float    "lat"
    t.float    "lng"
    t.integer  "dockcount"
    t.string   "landmark"
    t.date     "installation"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "stations", ["babs_id"], name: "index_stations_on_babs_id", unique: true, using: :btree

  create_table "trips", force: true do |t|
    t.integer  "babs_id"
    t.integer  "duration"
    t.datetime "start_time"
    t.string   "start_station_name"
    t.integer  "start_station_id"
    t.integer  "start_terminal"
    t.datetime "end_time"
    t.string   "end_station_name"
    t.integer  "end_station_id"
    t.integer  "end_terminal"
    t.integer  "bike_number"
    t.string   "subscription_type"
    t.string   "zip_code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "trips", ["babs_id"], name: "index_trips_on_babs_id", unique: true, using: :btree
  add_index "trips", ["end_station_id"], name: "index_trips_on_end_station_id", using: :btree
  add_index "trips", ["start_station_id"], name: "index_trips_on_start_station_id", using: :btree

end
