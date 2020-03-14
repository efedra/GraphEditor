# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_02_06_182640) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "edges", force: :cascade do |t|
    t.text "text"
    t.float "weight"
    t.bigint "start_id", null: false
    t.bigint "finish_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["finish_id"], name: "index_edges_on_finish_id"
    t.index ["start_id"], name: "index_edges_on_start_id"
  end

  create_table "graphs", force: :cascade do |t|
    t.string "name"
    t.jsonb "state", default: "{}", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "nodes", force: :cascade do |t|
    t.string "name"
    t.text "text"
    t.bigint "graph_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["graph_id"], name: "index_nodes_on_graph_id"
  end

  add_foreign_key "nodes", "graphs"
end
