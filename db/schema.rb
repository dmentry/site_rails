ActiveRecord::Schema.define(version: 2021_07_11_111102) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "articles", force: :cascade do |t|
    t.text "article_body"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "article_title"
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

  add_foreign_key "comments", "articles"
  add_foreign_key "photos", "types"
  add_foreign_key "photos", "users"
end
