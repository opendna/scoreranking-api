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

ActiveRecord::Schema.define(:version => 20140422013221) do

  create_table "ranking_version", :id => false, :force => true do |t|
    t.integer "app_id",                         :null => false
    t.integer "current_version", :default => 0
  end

  create_table "score__1__1", :id => false, :force => true do |t|
    t.integer   "user_id",     :null => false
    t.float     "score",       :null => false
    t.timestamp "inserted_at", :null => false
  end

  create_table "score__1__1_1", :id => false, :force => true do |t|
    t.integer   "user_id",     :null => false
    t.float     "score",       :null => false
    t.timestamp "inserted_at", :null => false
  end

  create_table "score__1__3_1", :id => false, :force => true do |t|
    t.integer   "user_id",     :null => false
    t.float     "score",       :null => false
    t.timestamp "inserted_at", :null => false
  end

  create_table "score__1__3_1_D0050", :id => false, :force => true do |t|
    t.integer   "user_id",     :null => false
    t.float     "score",       :null => false
    t.timestamp "inserted_at", :null => false
  end

  create_table "score__1__3_1_D0120", :id => false, :force => true do |t|
    t.integer   "user_id",     :null => false
    t.float     "score",       :null => false
    t.timestamp "inserted_at", :null => false
  end

  create_table "score__1__3_2", :id => false, :force => true do |t|
    t.integer   "user_id",     :null => false
    t.float     "score",       :null => false
    t.timestamp "inserted_at", :null => false
  end

  create_table "score__1__3_3", :id => false, :force => true do |t|
    t.integer   "user_id",     :null => false
    t.float     "score",       :null => false
    t.timestamp "inserted_at", :null => false
  end

  create_table "score__1__3_5", :id => false, :force => true do |t|
    t.integer   "user_id",     :null => false
    t.float     "score",       :null => false
    t.timestamp "inserted_at", :null => false
  end

  create_table "tests", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "userinfo_1", :primary_key => "user_id", :force => true do |t|
    t.text "user_data"
  end

end
