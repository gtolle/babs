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

ActiveRecord::Schema.define(version: 20140330061810) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "legs", force: true do |t|
    t.integer  "route_id"
    t.string   "distance_text"
    t.integer  "distance"
    t.string   "duration_text"
    t.integer  "duration"
    t.float    "start_lat"
    t.float    "start_lng"
    t.string   "start_addr"
    t.float    "end_lat"
    t.float    "end_lng"
    t.string   "end_addr"
    t.integer  "idx"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "legs", ["route_id"], name: "index_legs_on_route_id", using: :btree

  create_table "routes", force: true do |t|
    t.integer  "origin_station_id"
    t.integer  "destination_station_id"
    t.string   "summary"
    t.text     "overview_polyline"
    t.float    "bounds_ne_lat"
    t.float    "bounds_ne_lng"
    t.float    "bounds_sw_lat"
    t.float    "bounds_sw_lng"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "routes", ["destination_station_id"], name: "index_routes_on_destination_station_id", using: :btree
  add_index "routes", ["origin_station_id"], name: "index_routes_on_origin_station_id", using: :btree

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
  add_index "stations", ["landmark"], name: "index_stations_on_landmark", using: :btree

  create_table "steps", force: true do |t|
    t.integer  "route_id"
    t.integer  "leg_id"
    t.string   "distance_text"
    t.integer  "distance"
    t.string   "duration_text"
    t.integer  "duration"
    t.float    "start_lat"
    t.float    "start_lng"
    t.float    "end_lat"
    t.float    "end_lng"
    t.text     "html_instructions"
    t.text     "polyline"
    t.string   "maneuver"
    t.string   "travel_mode"
    t.integer  "idx"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "steps", ["leg_id"], name: "index_steps_on_leg_id", using: :btree
  add_index "steps", ["route_id"], name: "index_steps_on_route_id", using: :btree

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
    t.integer  "route_id"
    t.integer  "customer_zip_code_id"
  end

  add_index "trips", ["babs_id"], name: "index_trips_on_babs_id", unique: true, using: :btree
  add_index "trips", ["customer_zip_code_id"], name: "index_trips_on_customer_zip_code_id", using: :btree
  add_index "trips", ["end_station_id"], name: "index_trips_on_end_station_id", using: :btree
  add_index "trips", ["end_time"], name: "index_trips_on_end_time", using: :btree
  add_index "trips", ["route_id"], name: "index_trips_on_route_id", using: :btree
  add_index "trips", ["start_station_id"], name: "index_trips_on_start_station_id", using: :btree
  add_index "trips", ["start_time"], name: "index_trips_on_start_time", using: :btree

  create_table "zip_codes", force: true do |t|
    t.string   "code"
    t.float    "lat"
    t.float    "lng"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "zip_codes", ["code"], name: "index_zip_codes_on_code", unique: true, using: :btree

end
