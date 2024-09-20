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

ActiveRecord::Schema[7.2].define(version: 2024_09_20_122433) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "concerts", force: :cascade do |t|
    t.string "name"
    t.date "date"
    t.string "artist"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "report_bodies", force: :cascade do |t|
    t.bigint "report_id", null: false
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["report_id"], name: "index_report_bodies_on_report_id"
  end

  create_table "report_favorits", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "report_id"
    t.integer "favorit_report_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["report_id"], name: "index_report_favorits_on_report_id"
    t.index ["user_id"], name: "index_report_favorits_on_user_id"
  end

  create_table "reports", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "concert_id", null: false
    t.boolean "is_spoiler"
    t.date "spoiler_until"
    t.integer "report_status"
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
    t.integer "order"
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
  end

  create_table "tasks", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_favorits", force: :cascade do |t|
    t.bigint "user_id"
    t.integer "favorit_user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_user_favorits_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "x_account"
    t.string "profile"
    t.string "profile_image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "report_bodies", "reports"
  add_foreign_key "report_favorits", "reports"
  add_foreign_key "report_favorits", "users"
  add_foreign_key "reports", "concerts"
  add_foreign_key "reports", "users"
  add_foreign_key "sections", "reports"
  add_foreign_key "set_list_orders", "sections"
  add_foreign_key "set_list_orders", "songs"
  add_foreign_key "user_favorits", "users"
end
