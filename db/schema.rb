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

ActiveRecord::Schema.define(version: 2021_03_30_222418) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "alerts", force: :cascade do |t|
    t.string "status"
    t.integer "threshold_id"
    t.jsonb "metric", default: {}, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["threshold_id"], name: "index_alerts_on_threshold_id"
  end

  create_table "metrics", force: :cascade do |t|
    t.integer "txcount"
    t.integer "netpeers"
    t.integer "ingresscount"
    t.integer "egresscount"
    t.integer "procload"
    t.integer "sysload"
    t.integer "syswait"
    t.integer "threads"
    t.integer "writebytes"
    t.integer "readbytes"
    t.integer "memallocs"
    t.integer "memfrees"
    t.integer "mempauses"
    t.integer "memused"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "thresholds", force: :cascade do |t|
    t.string "name"
    t.integer "min"
    t.integer "max"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

end
