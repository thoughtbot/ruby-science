# encoding: UTF-8
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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20121128194213) do

  create_table "answers", :force => true do |t|
    t.integer  "completion_id", :null => false
    t.integer  "question_id",   :null => false
    t.string   "text",          :null => false
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "answers", ["completion_id"], :name => "index_answers_on_completion_id"
  add_index "answers", ["question_id"], :name => "index_answers_on_question_id"

  create_table "completions", :force => true do |t|
    t.integer  "survey_id",  :null => false
    t.integer  "user_id",    :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "completions", ["survey_id"], :name => "index_completions_on_survey_id"
  add_index "completions", ["user_id"], :name => "index_completions_on_user_id"

  create_table "options", :force => true do |t|
    t.integer  "question_id", :null => false
    t.string   "text",        :null => false
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "questions", :force => true do |t|
    t.string   "title",         :null => false
    t.string   "question_type", :null => false
    t.integer  "survey_id",     :null => false
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.integer  "minimum"
    t.integer  "maximum"
  end

  create_table "surveys", :force => true do |t|
    t.string   "title",      :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "author_id",  :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "encrypted_password", :limit => 128
    t.string   "salt",               :limit => 128
    t.string   "confirmation_token", :limit => 128
    t.string   "remember_token",     :limit => 128
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.string   "first_name"
    t.string   "last_name"
  end

  add_index "users", ["email"], :name => "index_users_on_email"
  add_index "users", ["remember_token"], :name => "index_users_on_remember_token"

end
