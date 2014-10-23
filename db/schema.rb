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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20141023082107) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "comment_flags", force: true do |t|
    t.integer  "user_id"
    t.integer  "comment_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comment_likes", force: true do |t|
    t.integer  "user_id"
    t.integer  "comment_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comment_unlikes", force: true do |t|
    t.integer  "user_id"
    t.integer  "comment_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", force: true do |t|
    t.integer  "user_id"
    t.integer  "school_id"
    t.string   "detail"
    t.integer  "flag_count"
    t.integer  "like_count"
    t.integer  "unlike_count"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["school_id"], name: "index_comments_on_school_id", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "follow_schools", force: true do |t|
    t.integer "user_id"
    t.integer "school_id"
  end

  create_table "followings", force: true do |t|
    t.integer  "user_id"
    t.integer  "followed_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "messages", force: true do |t|
    t.integer  "user_id"
    t.integer  "recipient_id"
    t.string   "detail"
    t.integer  "flag_count"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "messages", ["user_id"], name: "index_messages_on_user_id", using: :btree

  create_table "schools", force: true do |t|
    t.string   "name"
    t.string   "address"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.text     "maplink"
    t.string   "stype"
    t.string   "grades"
    t.string   "website"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "logo"
  end

  create_table "snapshot_flags", force: true do |t|
    t.integer  "user_id"
    t.integer  "snapshot_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "snapshot_likes", force: true do |t|
    t.integer  "user_id"
    t.integer  "snapshot_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "snapshot_unlikes", force: true do |t|
    t.integer  "user_id"
    t.integer  "snapshot_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "snapshots", force: true do |t|
    t.string   "URL"
    t.integer  "like_count"
    t.integer  "unlike_count"
    t.integer  "flag_count"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "snapshots", ["user_id"], name: "index_snapshots_on_user_id", using: :btree

  create_table "users", force: true do |t|
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
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "username"
    t.integer  "role"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "dob"
    t.string   "class_of"
    t.string   "authentication_token"
    t.integer  "school_id"
  end

  add_index "users", ["authentication_token"], name: "index_users_on_authentication_token", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
