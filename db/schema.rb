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

ActiveRecord::Schema.define(version: 20161112050706) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "affiliates", force: :cascade do |t|
    t.string   "name"
    t.string   "address"
    t.string   "postcode"
    t.string   "country"
    t.string   "telephone"
    t.datetime "deactivated_at"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.string   "url"
  end

  add_index "affiliates", ["name"], name: "index_affiliates_on_name", using: :btree

  create_table "attachments", force: :cascade do |t|
    t.string   "file"
    t.integer  "attachable_id"
    t.string   "attachable_type"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.datetime "deactivated_at"
  end

  create_table "child_collaborators", force: :cascade do |t|
    t.integer  "child_id"
    t.integer  "collaborator_id"
    t.string   "collaborator_type"
    t.datetime "deactivated_at"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  add_index "child_collaborators", ["child_id"], name: "index_child_collaborators_on_child_id", using: :btree

  create_table "children", force: :cascade do |t|
    t.string   "name"
    t.integer  "parent_id"
    t.integer  "department_id"
    t.datetime "birth_date"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "collaboration_invites", force: :cascade do |t|
    t.integer "child_id"
    t.integer "inviter_id"
    t.string  "invitee_email"
    t.integer "status",        default: 0
    t.string  "invite_code"
  end

  create_table "comments", force: :cascade do |t|
    t.integer  "discussion_id"
    t.integer  "owner_id"
    t.string   "content"
    t.datetime "deactivated_at"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "comments", ["discussion_id"], name: "index_comments_on_discussion_id", using: :btree
  add_index "comments", ["owner_id"], name: "index_comments_on_owner_id", using: :btree

  create_table "daycares", force: :cascade do |t|
    t.string   "name"
    t.string   "address_line1"
    t.string   "postcode"
    t.string   "country"
    t.string   "telephone"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "url"
    t.integer  "num_children"
    t.integer  "num_worker"
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

  create_table "discussion_participants", force: :cascade do |t|
    t.integer  "discussion_id"
    t.integer  "participant_id"
    t.string   "participant_type"
    t.boolean  "initiator"
    t.datetime "deactivated_at"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "discussion_participants", ["discussion_id"], name: "index_discussion_participants_on_discussion_id", using: :btree

  create_table "discussions", force: :cascade do |t|
    t.string   "title"
    t.integer  "subject_id"
    t.string   "subject_type"
    t.datetime "deactivated_at"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "owner_id"
    t.string   "content"
  end

  add_index "discussions", ["subject_type", "subject_id"], name: "index_discussions_on_subject_type_and_subject_id", using: :btree

  create_table "doctor_specializations", force: :cascade do |t|
    t.integer  "user_profile_id"
    t.integer  "medical_specialization_id"
    t.datetime "deactivated_at"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "health_record_components", force: :cascade do |t|
    t.integer  "health_record_id"
    t.string   "code"
    t.string   "value"
    t.datetime "deactivate_at"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "health_record_components", ["health_record_id"], name: "index_health_record_components_on_health_record_id", using: :btree

  create_table "health_records", force: :cascade do |t|
    t.string   "protocol_code"
    t.integer  "owner_id"
    t.string   "owner_type"
    t.integer  "recorder_id"
    t.string   "recorder_type"
    t.datetime "deactivated_at"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "daycare_id"
    t.integer  "department_id"
  end

  create_table "illnesses", force: :cascade do |t|
    t.string   "code"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "medical_specializations", force: :cascade do |t|
    t.string   "name"
    t.string   "code"
    t.integer  "added_by"
    t.datetime "deactivated_at"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "message_subjects", force: :cascade do |t|
    t.string   "title"
    t.integer  "parent_subject_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  add_index "message_subjects", ["parent_subject_id"], name: "index_message_subjects_on_parent_subject_id", using: :btree

  create_table "message_templates", force: :cascade do |t|
    t.integer  "sub_subject_id"
    t.integer  "target_role"
    t.string   "content"
    t.datetime "deactivated_at"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.string   "language"
  end

  add_index "message_templates", ["sub_subject_id"], name: "index_message_templates_on_sub_subject_id", using: :btree

  create_table "messages", force: :cascade do |t|
    t.integer  "message_template_id"
    t.integer  "owner_id"
    t.string   "title"
    t.string   "content"
    t.datetime "deactivated_at"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.string   "target_roles",        default: [],              array: true
  end

  add_index "messages", ["message_template_id"], name: "index_messages_on_message_template_id", using: :btree

  create_table "notifications", force: :cascade do |t|
    t.integer  "source_id"
    t.string   "source_type"
    t.integer  "target_id"
    t.boolean  "archived",    default: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  create_table "plans", force: :cascade do |t|
    t.string   "name"
    t.decimal  "price",      default: 0.0
    t.integer  "allocation", default: 0
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "sub_task_completes", force: :cascade do |t|
    t.integer  "submitter_id"
    t.integer  "todo_task_complete_id"
    t.integer  "sub_task_id"
    t.datetime "completion_date"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.integer  "result",                default: 0
  end

  create_table "sub_tasks", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "todo_task_id"
    t.datetime "deactivated_at"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.integer  "sub_task_type",  default: 0
  end

  create_table "subjects", force: :cascade do |t|
    t.string   "title"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.datetime "deactivated_at"
  end

  create_table "subscriptions", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "plan_id"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.boolean  "terms",      default: false
  end

  create_table "survey_answers", force: :cascade do |t|
    t.integer  "attempt_id"
    t.integer  "question_id"
    t.integer  "option_id"
    t.boolean  "correct"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "survey_attempts", force: :cascade do |t|
    t.integer  "participant_id"
    t.string   "participant_type"
    t.integer  "survey_id"
    t.boolean  "winner"
    t.integer  "score"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "survey_options", force: :cascade do |t|
    t.integer  "question_id"
    t.integer  "weight",         default: 0
    t.string   "text"
    t.boolean  "correct"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deactivated_at"
  end

  create_table "survey_questions", force: :cascade do |t|
    t.integer  "survey_id"
    t.string   "text"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deactivated_at"
  end

  create_table "survey_subjects", force: :cascade do |t|
    t.string   "title"
    t.integer  "daycare_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.text     "description"
    t.datetime "deactivated_at"
  end

  create_table "survey_surveys", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "attempts_number",   default: 0
    t.boolean  "finished",          default: false
    t.boolean  "active",            default: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "survey_subject_id"
    t.integer  "weight",            default: 0
    t.datetime "deactivated_at"
  end

  create_table "symptoms", force: :cascade do |t|
    t.integer  "illness_id"
    t.string   "code"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "task_type",   default: 0
  end

  create_table "todos", force: :cascade do |t|
    t.string   "title"
    t.integer  "iteration_type",        default: 0
    t.integer  "frequency",             default: 0
    t.integer  "daycare_id"
    t.integer  "user_id"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.integer  "completion_date_type",  default: 0
    t.integer  "completion_date_value", default: 1
  end

  create_table "user_affiliates", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "affiliate_id"
    t.datetime "deactivated_at"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "user_affiliates", ["affiliate_id"], name: "index_user_affiliates_on_affiliate_id", using: :btree
  add_index "user_affiliates", ["user_id"], name: "index_user_affiliates_on_user_id", using: :btree

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

  create_table "user_profiles", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "phone_number"
    t.string   "physical_address"
    t.string   "web_address"
    t.string   "about_yourself"
    t.string   "education"
    t.boolean  "online_presence",  default: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "certifications",   default: [],   array: true
  end

  create_table "user_todo_destroys", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "todo_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
    t.datetime "trial_end_date"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "votes", force: :cascade do |t|
    t.string   "vote_candidate_code"
    t.integer  "voter_id"
    t.string   "voter_type"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  add_index "votes", ["vote_candidate_code"], name: "index_votes_on_vote_candidate_code", using: :btree
  add_index "votes", ["voter_id"], name: "index_votes_on_voter_id", using: :btree

end
