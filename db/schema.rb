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

ActiveRecord::Schema[7.1].define(version: 2025_06_24_220912) do
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
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "actors", force: :cascade do |t|
    t.string "name"
    t.text "bio"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "actors_series", id: false, force: :cascade do |t|
    t.integer "actor_id", null: false
    t.integer "series_id", null: false
  end

  create_table "albums", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "year"
    t.integer "genre_id", null: false
    t.integer "author_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "likes_count", default: 0, null: false
    t.integer "user_id"
    t.index ["author_id"], name: "index_albums_on_author_id"
    t.index ["genre_id"], name: "index_albums_on_genre_id"
    t.index ["user_id"], name: "index_albums_on_user_id"
  end

  create_table "authors", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "genre_id", null: false
    t.integer "country_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.index ["country_id"], name: "index_authors_on_country_id"
    t.index ["genre_id"], name: "index_authors_on_genre_id"
    t.index ["user_id"], name: "index_authors_on_user_id"
  end

  create_table "authors_series", id: false, force: :cascade do |t|
    t.integer "series_id", null: false
    t.integer "author_id", null: false
  end

  create_table "collection_types", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_collection_types_on_name", unique: true
  end

  create_table "countries", force: :cascade do |t|
    t.string "name"
    t.string "code", limit: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_countries_on_code", unique: true
  end

  create_table "genres", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.integer "collection_type_id", null: false
    t.index ["collection_type_id"], name: "index_genres_on_collection_type_id"
    t.index ["user_id"], name: "index_genres_on_user_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "series_id", null: false
    t.text "message"
    t.boolean "read", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["series_id"], name: "index_notifications_on_series_id"
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "series", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "year"
    t.integer "genre_id", null: false
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "comments"
    t.boolean "seen"
    t.string "imdb_id"
    t.datetime "snoozed_at"
    t.index ["genre_id"], name: "index_series_on_genre_id"
    t.index ["user_id"], name: "index_series_on_user_id"
  end

  create_table "tv_shows", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "year"
    t.integer "genre_id", null: false
    t.integer "author_id", null: false
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_id"], name: "index_tv_shows_on_author_id"
    t.index ["genre_id"], name: "index_tv_shows_on_genre_id"
    t.index ["user_id"], name: "index_tv_shows_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "albums", "authors"
  add_foreign_key "albums", "genres"
  add_foreign_key "albums", "users"
  add_foreign_key "authors", "countries"
  add_foreign_key "authors", "genres"
  add_foreign_key "authors", "users"
  add_foreign_key "genres", "collection_types"
  add_foreign_key "genres", "users"
  add_foreign_key "notifications", "series"
  add_foreign_key "notifications", "users"
  add_foreign_key "series", "genres"
  add_foreign_key "series", "users"
  add_foreign_key "tv_shows", "authors"
  add_foreign_key "tv_shows", "genres"
  add_foreign_key "tv_shows", "users"
end
