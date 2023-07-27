# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2023_07_28_111233) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "abouts", force: :cascade do |t|
    t.text "main_text_ru"
    t.text "main_text_en"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "analytics", force: :cascade do |t|
    t.integer "views_period_month"
    t.integer "views_period_year"
    t.integer "uniq_visitor", default: 0, null: false
    t.integer "repeat_visitor", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["views_period_year", "views_period_month"], name: "idx_analytics_time_period"
  end

  create_table "articles", force: :cascade do |t|
    t.text "article_body_ru"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "article_title_ru"
    t.text "article_title_en"
    t.text "article_body_en"
  end

  create_table "comments", force: :cascade do |t|
    t.text "comment_body"
    t.bigint "article_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "comment_email"
    t.index ["article_id"], name: "index_comments_on_article_id"
  end

  create_table "photos", force: :cascade do |t|
    t.string "photo"
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "description"
    t.bigint "type_id"
    t.text "lat"
    t.text "long"
    t.index ["type_id"], name: "index_photos_on_type_id"
    t.index ["user_id"], name: "index_photos_on_user_id"
  end

  create_table "types", force: :cascade do |t|
    t.text "photo_type", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "visitors", force: :cascade do |t|
    t.datetime "time_visited"
    t.string "page_name"
    t.string "referrer"
    t.string "browser_name"
    t.string "browser_platform"
    t.string "browser_language"
    t.string "size_screen_w"
    t.string "size_screen_h"
    t.string "country"
    t.string "region_name"
    t.string "lat"
    t.string "lon"
    t.string "timezone"
    t.boolean "uniq_visitor", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["uniq_visitor"], name: "index_visitors_on_uniq_visitor"
  end

  add_foreign_key "comments", "articles"
  add_foreign_key "photos", "types"
  add_foreign_key "photos", "users"
end
