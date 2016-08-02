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

ActiveRecord::Schema.define(version: 20160802015546) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "clothing_colors", force: :cascade do |t|
    t.integer  "clothing_id",                null: false
    t.integer  "color_id",                   null: false
    t.string   "image",                      null: false
    t.boolean  "active",      default: true, null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.index ["active"], name: "index_clothing_colors_on_active", using: :btree
    t.index ["clothing_id", "color_id"], name: "index_clothing_colors_on_clothing_id_and_color_id", unique: true, using: :btree
  end

  create_table "clothing_tags", force: :cascade do |t|
    t.integer "clothing_id"
    t.integer "tag_id"
    t.index ["clothing_id", "tag_id"], name: "index_clothing_tags_on_clothing_id_and_tag_id", unique: true, using: :btree
  end

  create_table "clothings", force: :cascade do |t|
    t.string   "base_name",                            null: false
    t.string   "clothing_type",    default: "T-Shirt", null: false
    t.string   "style",                                null: false
    t.string   "gender",                               null: false
    t.integer  "price",                                null: false
    t.text     "sizes",            default: [],        null: false, array: true
    t.integer  "weight",                               null: false
    t.string   "extension"
    t.string   "handle_extension", default: "",        null: false
    t.boolean  "active",           default: true,      null: false
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.string   "sku"
    t.index ["active"], name: "index_clothings_on_active", using: :btree
    t.index ["base_name"], name: "index_clothings_on_base_name", unique: true, using: :btree
    t.index ["clothing_type"], name: "index_clothings_on_clothing_type", using: :btree
  end

  create_table "colors", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "sku"
    t.index ["name"], name: "index_colors_on_name", unique: true, using: :btree
  end

  create_table "tags", force: :cascade do |t|
    t.text     "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_tags_on_name", unique: true, using: :btree
  end

  create_table "teams", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_teams_on_name", unique: true, using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",         null: false
    t.string   "password_hash", null: false
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["email"], name: "index_users_on_email", using: :btree
  end

end
