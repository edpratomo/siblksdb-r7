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

ActiveRecord::Schema[7.2].define(version: 2024_12_07_025641) do
  create_schema "siblksdb"

  # These are extensions that must be enabled in order to support this database
  enable_extension "hstore"
  enable_extension "pg_redispub"
  enable_extension "pg_trgm"
  enable_extension "plpgsql"
  enable_extension "postgres_fdw"
  enable_extension "uuid-ossp"

  create_table "admissions", id: :serial, force: :cascade do |t|
    t.text "name", null: false
    t.text "birthplace"
    t.date "birthdate"
    t.text "sex", null: false
    t.text "phone"
    t.text "email"
    t.timestamptz "created_at", default: -> { "clock_timestamp()" }, null: false
    t.timestamptz "modified_at", default: -> { "clock_timestamp()" }, null: false
    t.text "modified_by"
    t.string "avatar_file_name", limit: 255
    t.string "avatar_content_type", limit: 255
    t.integer "avatar_file_size"
    t.datetime "avatar_updated_at", precision: nil
    t.hstore "biodata"
    t.text "religion"
    t.text "street_address"
    t.text "district"
    t.text "regency_city"
    t.text "province"
    t.text "employment", default: "belum bekerja", null: false
    t.check_constraint "sex = ANY (ARRAY['female'::text, 'male'::text])", name: "students_sex_check"
  end

  create_table "changes", id: :serial, force: :cascade do |t|
    t.text "table_name", null: false
    t.timestamptz "action_tstamp", default: -> { "clock_timestamp()" }, null: false
    t.text "action", null: false
    t.text "original_data"
    t.text "new_data"
    t.text "query"
    t.text "modified_by"
    t.check_constraint "action = ANY (ARRAY['I'::text, 'D'::text, 'U'::text])", name: "changes_action_check"
  end

  create_table "courses_admissions", id: :serial, force: :cascade do |t|
    t.integer "admission_id", null: false
    t.integer "course_id", null: false
    t.text "modified_by"
    t.timestamptz "created_at", default: -> { "clock_timestamp()" }, null: false
    t.timestamptz "updated_at", default: -> { "clock_timestamp()" }, null: false
  end

  create_table "fees", id: :serial, force: :cascade do |t|
    t.text "type", null: false
    t.integer "amount", null: false
    t.timestamptz "active_since"
    t.text "modified_by"
    t.timestamptz "created_at", default: -> { "clock_timestamp()" }, null: false
    t.timestamptz "updated_at", default: -> { "clock_timestamp()" }, null: false
    t.integer "course_id"
    t.integer "program_id"
  end

  create_table "groups", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "invoice_items", id: :serial, force: :cascade do |t|
    t.integer "invoice_id", null: false
    t.integer "quantity", default: 1, null: false
    t.text "description", null: false
    t.integer "fee_id", null: false
    t.integer "course_id", null: false
  end

  create_table "invoices", id: :serial, force: :cascade do |t|
    t.text "invoiceable_type", null: false
    t.integer "invoiceable_id", null: false
    t.integer "amount", default: 0, null: false
    t.boolean "paid", default: false, null: false
    t.text "modified_by"
    t.timestamptz "created_at", default: -> { "clock_timestamp()" }, null: false
    t.timestamptz "modified_at", default: -> { "clock_timestamp()" }, null: false
  end

  create_table "payments", id: :serial, force: :cascade do |t|
    t.integer "invoice_id", null: false
    t.integer "amount", null: false
    t.text "modified_by"
    t.timestamptz "created_at", default: -> { "clock_timestamp()" }, null: false
    t.timestamptz "updated_at", default: -> { "clock_timestamp()" }, null: false
  end

  create_table "refunds", id: :serial, force: :cascade do |t|
    t.integer "invoice_id", null: false
    t.integer "amount", null: false
    t.text "reason", default: "excess_payment", null: false
    t.timestamptz "paid_at"
    t.text "modified_by"
    t.timestamptz "created_at", default: -> { "clock_timestamp()" }, null: false
    t.timestamptz "updated_at", default: -> { "clock_timestamp()" }, null: false
    t.index ["paid_at"], name: "refunds_paid_at_idx"
  end

  create_table "users", force: :cascade do |t|
    t.string "fullname", default: "", null: false
    t.string "username", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at", precision: nil
    t.datetime "remember_created_at", precision: nil
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at", precision: nil
    t.datetime "last_sign_in_at", precision: nil
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "group_id", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["group_id"], name: "index_users_on_group_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "courses_admissions", "admissions", name: "courses_admissions_admission_id_fkey"
  add_foreign_key "invoice_items", "fees", name: "invoice_items_fee_id_fkey"
  add_foreign_key "invoice_items", "invoices", name: "invoice_items_invoice_id_fkey"
  add_foreign_key "payments", "invoices", name: "payments_invoice_id_fkey"
  add_foreign_key "refunds", "invoices", name: "refunds_invoice_id_fkey"
  add_foreign_key "users", "groups"
end
