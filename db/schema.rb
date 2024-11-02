# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.2].define(version: 2024_10_31_055435) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "concerts", force: :cascade do |t|
    t.string "name"
    t.date "date"
    t.string "artist"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["date"], name: "index_concerts_on_date"
  end

  create_table "report_bodies", force: :cascade do |t|
    t.bigint "report_id", null: false
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["report_id"], name: "index_report_bodies_on_report_id"
  end

  create_table "report_favorites", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "report_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["report_id"], name: "index_report_favorites_on_report_id"
    t.index ["user_id", "report_id"], name: "index_report_favorites_on_user_id_and_report_id", unique: true
    t.index ["user_id"], name: "index_report_favorites_on_user_id"
  end

  create_table "reports", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "concert_id"
    t.boolean "is_spoiler"
    t.date "spoiler_until"
    t.integer "report_status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["concert_id"], name: "index_reports_on_concert_id"
    t.index ["user_id"], name: "index_reports_on_user_id"
  end

  create_table "sections", force: :cascade do |t|
    t.bigint "report_id", null: false
    t.string "name"
    t.integer "order"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["report_id"], name: "index_sections_on_report_id"
  end

  create_table "set_list_orders", force: :cascade do |t|
    t.bigint "section_id", null: false
    t.bigint "song_id", null: false
    t.integer "position"
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["section_id"], name: "index_set_list_orders_on_section_id"
    t.index ["song_id"], name: "index_set_list_orders_on_song_id"
  end

  create_table "songs", force: :cascade do |t|
    t.string "name"
    t.string "artist"
    t.string "spotify_track_id"
    t.string "spotify_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["artist"], name: "index_songs_on_artist"
    t.index ["name"], name: "index_songs_on_name"
  end

  create_table "tasks", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_favorites", force: :cascade do |t|
    t.bigint "user_id"
    t.integer "favorited_user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "favorited_user_id"], name: "index_user_favorites_on_user_id_and_favorited_user_id", unique: true
    t.index ["user_id"], name: "index_user_favorites_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "x_account"
    t.string "profile"
    t.string "profile_image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "crypted_password"
    t.string "salt"
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "report_bodies", "reports"
  add_foreign_key "report_favorites", "reports"
  add_foreign_key "report_favorites", "users"
  add_foreign_key "reports", "concerts"
  add_foreign_key "reports", "users"
  add_foreign_key "sections", "reports"
  add_foreign_key "set_list_orders", "sections"
  add_foreign_key "set_list_orders", "songs"
  add_foreign_key "user_favorites", "users"
  add_foreign_key "user_favorites", "users", column: "favorited_user_id"
end
