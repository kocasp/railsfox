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

ActiveRecord::Schema.define(version: 20170816135743) do

  create_table "connections", force: :cascade do |t|
    t.integer  "station_id"
    t.integer  "connected_station_id"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "courses", force: :cascade do |t|
    t.datetime "departure_time"
    t.datetime "arrival_time"
    t.integer  "connection_id"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.decimal  "price",          precision: 8, scale: 2
  end

  create_table "sidekiq_jobs", force: :cascade do |t|
    t.string   "jid"
    t.string   "queue"
    t.string   "class_name"
    t.text     "args"
    t.boolean  "retry"
    t.datetime "enqueued_at"
    t.datetime "started_at"
    t.datetime "finished_at"
    t.string   "status"
    t.string   "name"
    t.text     "result"
  end

  add_index "sidekiq_jobs", ["class_name"], name: "index_sidekiq_jobs_on_class_name"
  add_index "sidekiq_jobs", ["enqueued_at"], name: "index_sidekiq_jobs_on_enqueued_at"
  add_index "sidekiq_jobs", ["finished_at"], name: "index_sidekiq_jobs_on_finished_at"
  add_index "sidekiq_jobs", ["jid"], name: "index_sidekiq_jobs_on_jid"
  add_index "sidekiq_jobs", ["queue"], name: "index_sidekiq_jobs_on_queue"
  add_index "sidekiq_jobs", ["retry"], name: "index_sidekiq_jobs_on_retry"
  add_index "sidekiq_jobs", ["started_at"], name: "index_sidekiq_jobs_on_started_at"
  add_index "sidekiq_jobs", ["status"], name: "index_sidekiq_jobs_on_status"

  create_table "stations", force: :cascade do |t|
    t.string   "name"
    t.integer  "connection_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

end
