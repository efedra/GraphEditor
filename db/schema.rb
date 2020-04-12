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

ActiveRecord::Schema.define(version: 2020_04_12_131011) do

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

  create_table "graphs_users", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "graph_id"
    t.integer "scope", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["graph_id"], name: "index_graphs_users_on_graph_id"
    t.index ["scope"], name: "index_graphs_users_on_scope"
    t.index ["user_id", "graph_id"], name: "index_graphs_users_on_user_id_and_graph_id", unique: true
    t.index ["user_id"], name: "index_graphs_users_on_user_id"
  end

  create_table "nodes", force: :cascade do |t|
    t.string "name"
    t.text "text"
    t.bigint "graph_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "html_x"
    t.integer "html_y"
    t.string "html_color"
    t.integer "kind", default: 0, null: false
    t.index ["graph_id"], name: "index_nodes_on_graph_id"
    t.index ["kind"], name: "index_nodes_on_kind"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "graphs_users", "graphs"
  add_foreign_key "graphs_users", "users"
  add_foreign_key "nodes", "graphs"
end
