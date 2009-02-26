# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090226061214) do

  create_table "friends", :force => true do |t|
    t.integer  "user_id_1"
    t.integer  "user_id_2"
    t.boolean  "accepted"
    t.boolean  "rejected"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "news", :force => true do |t|
    t.text     "text"
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sleeps", :force => true do |t|
    t.datetime "start"
    t.datetime "stop"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "zip"
    t.integer  "quality"
    t.string   "note"
  end

  create_table "tags", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "email"
    t.string   "password"
    t.string   "realname"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "public_profile"
    t.string   "zip"
    t.decimal  "target_hours"
    t.string   "twitter"
    t.boolean  "admin"
  end

end
