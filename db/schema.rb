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

ActiveRecord::Schema.define(version: 20160404153821) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "attachments", force: :cascade do |t|
    t.string   "file"
    t.integer  "attachable_id"
    t.string   "attachable_type"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "children", force: :cascade do |t|
    t.string   "name"
    t.integer  "parent_id"
    t.integer  "department_id"
    t.datetime "birth_date"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "daycares", force: :cascade do |t|
    t.string   "name"
    t.string   "address_line1"
    t.string   "postcode"
    t.string   "country"
    t.string   "telephone"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "department_todos", force: :cascade do |t|
    t.integer  "todo_id"
    t.integer  "department_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "departments", force: :cascade do |t|
    t.string   "name"
    t.integer  "daycare_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "discount_code_users", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "discount_code_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "discount_codes", force: :cascade do |t|
    t.string   "code"
    t.integer  "value",      default: 0
    t.integer  "status",     default: 0
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "plans", force: :cascade do |t|
    t.string   "name"
    t.decimal  "price",      default: 0.0
    t.integer  "allocation", default: 0
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "subscriptions", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "plan_id"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.boolean  "terms",      default: false
  end

  create_table "todo_completes", force: :cascade do |t|
    t.integer  "submitter_id"
    t.integer  "todo_id"
    t.datetime "completion_date"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "status",          default: 0
  end

  create_table "todo_task_completes", force: :cascade do |t|
    t.integer  "submitter_id"
    t.integer  "todo_complete_id"
    t.integer  "todo_task_id"
    t.datetime "completion_date"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.integer  "result",           default: 0
  end

  create_table "todo_tasks", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "todo_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "todos", force: :cascade do |t|
    t.string   "title"
    t.integer  "iteration_type", default: 0
    t.integer  "frequency",      default: 0
    t.integer  "daycare_id"
    t.integer  "user_id"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "user_daycares", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "daycare_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_occurrences", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "todo_id"
    t.integer  "status",     default: 0
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.integer  "role",                   default: 0
    t.string   "name"
    t.string   "stripe_customer_token"
    t.integer  "department_id"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
