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

ActiveRecord::Schema.define(version: 20160921194342) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admins", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "artists", force: :cascade do |t|
    t.text     "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "bookings", force: :cascade do |t|
    t.datetime "start_time"
    t.datetime "end_time"
    t.integer  "length"
    t.integer  "karaoke_room_id"
    t.index ["karaoke_room_id"], name: "index_bookings_on_karaoke_room_id", using: :btree
  end

  create_table "favorites", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "user_id"
    t.integer  "song_id"
    t.index ["song_id"], name: "index_favorites_on_song_id", using: :btree
    t.index ["user_id"], name: "index_favorites_on_user_id", using: :btree
  end

  create_table "karaoke_rooms", force: :cascade do |t|
    t.string "name"
    t.json   "queue"
    t.json   "singers"
  end

  create_table "karaoke_sessions", force: :cascade do |t|
    t.string   "token"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.datetime "start_time"
    t.datetime "end_time"
    t.boolean  "is_active"
    t.integer  "karaoke_room_id"
    t.index ["karaoke_room_id"], name: "index_karaoke_sessions_on_karaoke_room_id", using: :btree
  end

  create_table "karaoke_sessions_users", id: false, force: :cascade do |t|
    t.integer "karaoke_sessions_id"
    t.integer "users_id"
    t.index ["karaoke_sessions_id"], name: "index_karaoke_sessions_users_on_karaoke_sessions_id", using: :btree
    t.index ["users_id"], name: "index_karaoke_sessions_users_on_users_id", using: :btree
  end

  create_table "pg_search_documents", force: :cascade do |t|
    t.text     "content"
    t.string   "searchable_type"
    t.integer  "searchable_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["searchable_type", "searchable_id"], name: "index_pg_search_documents_on_searchable_type_and_searchable_id", using: :btree
  end

  create_table "plays", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "song_id"
    t.integer  "karaoke_session_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.index ["karaoke_session_id"], name: "index_plays_on_karaoke_session_id", using: :btree
    t.index ["song_id"], name: "index_plays_on_song_id", using: :btree
    t.index ["user_id"], name: "index_plays_on_user_id", using: :btree
  end

  create_table "songs", force: :cascade do |t|
    t.string   "title"
    t.string   "location"
    t.string   "category"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "soID"
    t.integer  "artist_id"
    t.index ["artist_id"], name: "index_songs_on_artist_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "username"
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
    t.index ["username"], name: "index_users_on_username", unique: true, using: :btree
  end

  add_foreign_key "bookings", "karaoke_rooms"
  add_foreign_key "favorites", "songs"
  add_foreign_key "favorites", "users"
  add_foreign_key "karaoke_sessions", "karaoke_rooms"
  add_foreign_key "songs", "artists"
end
