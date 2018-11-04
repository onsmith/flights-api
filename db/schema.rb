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

ActiveRecord::Schema.define(version: 20181104040803) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "airlines", force: :cascade do |t|
    t.string "name", null: false
    t.string "logo_url"
    t.bigint "user_id"
    t.text "info"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_airlines_on_user_id"
  end

  create_table "airports", force: :cascade do |t|
    t.string "name", null: false
    t.string "code", null: false
    t.string "latitude"
    t.string "longitude"
    t.string "city"
    t.string "state"
    t.string "city_url"
    t.bigint "user_id"
    t.text "info"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_airports_on_user_id"
  end

  create_table "flights", force: :cascade do |t|
    t.time "departs_at", null: false
    t.time "arrives_at", null: false
    t.string "number", null: false
    t.bigint "departure_id", null: false
    t.bigint "arrival_id", null: false
    t.bigint "plane_id"
    t.bigint "airline_id"
    t.bigint "next_flight_id"
    t.bigint "user_id"
    t.text "info"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["airline_id"], name: "index_flights_on_airline_id"
    t.index ["arrival_id"], name: "index_flights_on_arrival_id"
    t.index ["departure_id"], name: "index_flights_on_departure_id"
    t.index ["next_flight_id"], name: "index_flights_on_next_flight_id"
    t.index ["plane_id"], name: "index_flights_on_plane_id"
    t.index ["user_id"], name: "index_flights_on_user_id"
  end

  create_table "instances", force: :cascade do |t|
    t.bigint "flight_id", null: false
    t.date "date", null: false
    t.boolean "is_cancelled", default: false, null: false
    t.bigint "user_id"
    t.text "info"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["flight_id"], name: "index_instances_on_flight_id"
    t.index ["user_id"], name: "index_instances_on_user_id"
  end

  create_table "itineraries", force: :cascade do |t|
    t.string "confirmation_code"
    t.string "email"
    t.bigint "user_id"
    t.text "info"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_itineraries_on_user_id"
  end

  create_table "planes", force: :cascade do |t|
    t.string "name", null: false
    t.string "seatmap_url"
    t.bigint "airline_id"
    t.bigint "user_id"
    t.text "info"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["airline_id"], name: "index_planes_on_airline_id"
    t.index ["user_id"], name: "index_planes_on_user_id"
  end

  create_table "seats", force: :cascade do |t|
    t.string "class"
    t.integer "row", null: false
    t.string "number", null: false
    t.boolean "is_window", default: false, null: false
    t.boolean "is_isle", default: false, null: false
    t.boolean "is_exit", default: false, null: false
    t.bigint "plane_id", null: false
    t.bigint "user_id"
    t.text "info"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["plane_id"], name: "index_seats_on_plane_id"
    t.index ["user_id"], name: "index_seats_on_user_id"
  end

  create_table "tickets", force: :cascade do |t|
    t.string "first_name", null: false
    t.string "middle_name"
    t.string "last_name", null: false
    t.integer "age", null: false
    t.string "gender", null: false
    t.float "is_purchased", default: 0.0, null: false
    t.float "price_paid"
    t.bigint "seat_id", null: false
    t.bigint "instance_id", null: false
    t.bigint "itinerary_id"
    t.bigint "user_id"
    t.text "info"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["instance_id"], name: "index_tickets_on_instance_id"
    t.index ["itinerary_id"], name: "index_tickets_on_itinerary_id"
    t.index ["seat_id"], name: "index_tickets_on_seat_id"
    t.index ["user_id"], name: "index_tickets_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.index ["username"], name: "index_users_on_username", unique: true
  end

end
