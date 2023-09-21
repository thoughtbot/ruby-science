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

ActiveRecord::Schema[7.0].define(version: 2023_10_06_184257) do
  create_table "answers", force: :cascade do |t|
    t.integer "completion_id", null: false
    t.integer "question_id", null: false
    t.string "text", limit: 255, null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["completion_id"], name: "index_answers_on_completion_id"
    t.index ["question_id"], name: "index_answers_on_question_id"
  end

  create_table "completions", force: :cascade do |t|
    t.integer "survey_id", null: false
    t.integer "user_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["survey_id"], name: "index_completions_on_survey_id"
    t.index ["user_id"], name: "index_completions_on_user_id"
  end

  create_table "invitations", force: :cascade do |t|
    t.integer "sender_id"
    t.integer "survey_id"
    t.string "recipient_email", limit: 255
    t.string "status", limit: 255, default: "pending"
    t.string "token", limit: 255
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.text "message", default: "", null: false
    t.index ["survey_id"], name: "index_invitations_on_survey_id"
    t.index ["token"], name: "index_invitations_on_token", unique: true
  end

  create_table "messages", force: :cascade do |t|
    t.integer "sender_id", null: false
    t.integer "recipient_id", null: false
    t.text "body", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "multiple_choice_submittables", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "open_submittables", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "options", force: :cascade do |t|
    t.integer "question_id", null: false
    t.string "text", limit: 255, null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "score", default: 0, null: false
  end

  create_table "questions", force: :cascade do |t|
    t.string "title", limit: 255, null: false
    t.integer "survey_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "submittable_id"
    t.string "submittable_type", limit: 255
  end

  create_table "scale_submittables", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "minimum"
    t.integer "maximum"
  end

  create_table "surveys", force: :cascade do |t|
    t.string "title", limit: 255, null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "author_id", null: false
  end

  create_table "unsubscribes", force: :cascade do |t|
    t.string "email", limit: 255, null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["email"], name: "index_unsubscribes_on_email"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", limit: 255
    t.string "encrypted_password", limit: 128
    t.string "salt", limit: 128
    t.string "confirmation_token", limit: 128
    t.string "remember_token", limit: 128
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "first_name", limit: 255
    t.string "last_name", limit: 255
    t.index ["email"], name: "index_users_on_email"
    t.index ["remember_token"], name: "index_users_on_remember_token"
  end

end
