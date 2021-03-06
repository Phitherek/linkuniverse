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

ActiveRecord::Schema.define(version: 20170718092619) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "comments", force: true do |t|
    t.text     "content"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "commentable_id"
    t.string   "commentable_type"
  end

  create_table "link_collection_memberships", force: true do |t|
    t.integer  "user_id"
    t.integer  "link_collection_id"
    t.string   "permission",         default: "view", null: false
    t.boolean  "active",             default: false,  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "link_collections", force: true do |t|
    t.string   "name"
    t.boolean  "pub",         default: false, null: false
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "parent_id"
    t.text     "description"
  end

  create_table "link_collections_users", id: false, force: true do |t|
    t.integer "user_id"
    t.integer "link_collection_id"
  end

  create_table "links", force: true do |t|
    t.string   "title"
    t.text     "description"
    t.string   "url",           null: false
    t.integer  "collection_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id",       null: false
  end

  create_table "users", force: true do |t|
    t.string   "username"
    t.string   "email"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_digest",                        default: "",    null: false
    t.boolean  "active",                                 default: false, null: false
    t.string   "activation_token",                       default: "",    null: false
    t.boolean  "password_reset_used",                    default: true,  null: false
    t.string   "password_reset_token",                   default: "",    null: false
    t.boolean  "invitation_notification_enabled",        default: true,  null: false
    t.boolean  "invitation_accept_notification_enabled", default: true,  null: false
  end

  create_table "votes", force: true do |t|
    t.integer  "user_id"
    t.boolean  "positive",      default: true, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "voteable_id"
    t.string   "voteable_type"
  end

end
