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

ActiveRecord::Schema.define(version: 2020_04_25_214524) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "booking_details", force: :cascade do |t|
    t.bigint "booking_id", null: false
    t.bigint "room_id", null: false
    t.integer "quantity"
    t.integer "subtotal"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["booking_id"], name: "index_booking_details_on_booking_id"
    t.index ["room_id"], name: "index_booking_details_on_room_id"
  end

  create_table "bookings", force: :cascade do |t|
    t.string "client_name"
    t.string "client_email"
    t.date "date_start"
    t.date "date_end"
    t.date "date_creation"
    t.integer "total_amount"
    t.boolean "booking_state"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "cancelled_at"
    t.boolean "notified"
    t.bigint "estate_id"
    t.index ["estate_id"], name: "index_bookings_on_estate_id"
  end

  create_table "cities", force: :cascade do |t|
    t.string "name"
    t.bigint "departament_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["departament_id"], name: "index_cities_on_departament_id"
  end

  create_table "comments", force: :cascade do |t|
    t.string "description"
    t.integer "rating"
    t.string "client_name"
    t.string "client_email"
    t.bigint "estate_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["estate_id"], name: "index_comments_on_estate_id"
  end

  create_table "data_migrations", primary_key: "version", id: :string, force: :cascade do |t|
  end

  create_table "departaments", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "estates", force: :cascade do |t|
    t.string "name"
    t.string "address"
    t.bigint "city_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "owner_id", null: false
    t.string "estate_type"
    t.boolean "status", default: false, null: false
    t.string "description"
    t.datetime "deleted_at"
    t.integer "score", default: 0
    t.integer "comments_quant", default: 0
    t.integer "comments_rating_total", default: 0
    t.boolean "booking_cancelable"
    t.index ["city_id"], name: "index_estates_on_city_id"
    t.index ["deleted_at"], name: "index_estates_on_deleted_at"
    t.index ["owner_id"], name: "index_estates_on_owner_id"
  end

  create_table "facilities", force: :cascade do |t|
    t.string "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "facility_type"
  end

  create_table "facilities_estates", id: false, force: :cascade do |t|
    t.bigint "facility_id"
    t.bigint "estate_id"
    t.index ["estate_id"], name: "index_facilities_estates_on_estate_id"
    t.index ["facility_id"], name: "index_facilities_estates_on_facility_id"
  end

  create_table "facilities_rooms", id: false, force: :cascade do |t|
    t.bigint "facility_id"
    t.bigint "room_id"
    t.index ["facility_id"], name: "index_facilities_rooms_on_facility_id"
    t.index ["room_id"], name: "index_facilities_rooms_on_room_id"
  end

  create_table "offer_details", force: :cascade do |t|
    t.bigint "room_id"
    t.integer "discount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "offer_id"
    t.index ["offer_id"], name: "index_offer_details_on_offer_id"
    t.index ["room_id"], name: "index_offer_details_on_room_id"
  end

  create_table "offers", force: :cascade do |t|
    t.bigint "estate_id"
    t.string "description"
    t.date "date_start"
    t.date "date_end"
    t.date "date_creation"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["estate_id"], name: "index_offers_on_estate_id"
  end

  create_table "owners", force: :cascade do |t|
    t.string "phone"
    t.string "address"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "about"
    t.string "name"
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_owners_on_user_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.string "resource_type"
    t.bigint "resource_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id"
    t.index ["resource_type", "resource_id"], name: "index_roles_on_resource_type_and_resource_id"
  end

  create_table "rooms", force: :cascade do |t|
    t.string "description"
    t.string "capacity"
    t.integer "price"
    t.string "status"
    t.string "room_type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "estate_id", null: false
    t.integer "quantity"
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_rooms_on_deleted_at"
    t.index ["estate_id"], name: "index_rooms_on_estate_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.string "username"
    t.string "name"
    t.string "last_name"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  create_table "users_roles", id: false, force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "role_id"
    t.index ["role_id"], name: "index_users_roles_on_role_id"
    t.index ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id"
    t.index ["user_id"], name: "index_users_roles_on_user_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "booking_details", "bookings"
  add_foreign_key "booking_details", "rooms"
  add_foreign_key "bookings", "estates"
  add_foreign_key "cities", "departaments"
  add_foreign_key "comments", "estates"
  add_foreign_key "estates", "cities"
  add_foreign_key "estates", "owners"
  add_foreign_key "offer_details", "offers"
  add_foreign_key "offer_details", "rooms"
  add_foreign_key "offers", "estates"
  add_foreign_key "owners", "users"
  add_foreign_key "rooms", "estates"
end
