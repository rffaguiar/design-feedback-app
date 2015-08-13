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

ActiveRecord::Schema.define(version: 20150408230557) do

  create_table "admins", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admins", ["email"], name: "index_admins_on_email", unique: true, using: :btree
  add_index "admins", ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true, using: :btree

  create_table "comments", force: :cascade do |t|
    t.string   "comment",    limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "spot_id",    limit: 4
    t.integer  "user_id",    limit: 4
    t.integer  "design_id",  limit: 4
  end

  add_index "comments", ["design_id"], name: "index_comments_on_design_id", using: :btree
  add_index "comments", ["spot_id"], name: "index_comments_on_spot_id", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "designs", force: :cascade do |t|
    t.string   "title",            limit: 255
    t.string   "subtitle",         limit: 255
    t.string   "link",             limit: 255
    t.string   "image_path",       limit: 255
    t.integer  "user_id",          limit: 4
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.string   "image_thumb_path", limit: 255
  end

  add_index "designs", ["link"], name: "index_designs_on_link", unique: true, using: :btree
  add_index "designs", ["user_id"], name: "index_designs_on_user_id", using: :btree

  create_table "spots", force: :cascade do |t|
    t.string   "x_pos",      limit: 255
    t.string   "y_pos",      limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "design_id",  limit: 4
    t.integer  "user_id",    limit: 4
  end

  add_index "spots", ["design_id", "x_pos", "y_pos"], name: "index_spots_on_design_id_and_x_pos_and_y_pos", unique: true, using: :btree
  add_index "spots", ["design_id"], name: "index_spots_on_design_id", using: :btree
  add_index "spots", ["user_id"], name: "index_spots_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "name",                   limit: 255
    t.string   "email",                  limit: 255
    t.string   "address",                limit: 255
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "comments", "designs"
  add_foreign_key "comments", "spots"
  add_foreign_key "comments", "users"
  add_foreign_key "designs", "users"
  add_foreign_key "spots", "designs"
  add_foreign_key "spots", "users"
end
