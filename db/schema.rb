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

ActiveRecord::Schema.define(version: 20170813161852) do

  create_table "carriers", force: :cascade do |t|
    t.string "name"
  end

  create_table "cities", force: :cascade do |t|
    t.string "name"
  end

  create_table "currencies", force: :cascade do |t|
    t.string "name"
  end

  create_table "route_logs", force: :cascade do |t|
    t.integer "start_station_id"
    t.integer "finish_station_id"
    t.datetime "departure_date_time"
    t.datetime "arrival_date_time"
    t.integer "carrier_id"
    t.integer "currency_id"
    t.float "total_cost"
    t.index ["carrier_id"], name: "index_route_logs_on_carrier_id"
    t.index ["currency_id"], name: "index_route_logs_on_currency_id"
    t.index ["finish_station_id"], name: "index_route_logs_on_finish_station_id"
    t.index ["start_station_id"], name: "index_route_logs_on_start_station_id"
  end

  create_table "routes", force: :cascade do |t|
    t.integer "start_station_id"
    t.integer "finish_station_id"
    t.integer "weekday"
    t.integer "departure_hours"
    t.integer "departure_minutes"
    t.integer "arrival_hours"
    t.integer "arrival_minutes"
    t.integer "carrier_id"
    t.index ["carrier_id"], name: "index_routes_on_carrier_id"
    t.index ["finish_station_id"], name: "index_routes_on_finish_station_id"
    t.index ["start_station_id"], name: "index_routes_on_start_station_id"
  end

  create_table "stations", force: :cascade do |t|
    t.integer "city_id"
    t.string "name"
    t.index ["city_id"], name: "index_stations_on_city_id"
  end

end
