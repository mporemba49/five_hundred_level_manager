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

ActiveRecord::Schema.define(version: 20160925153156) do

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

  create_table "clothing_sizes", force: :cascade do |t|
    t.integer "clothing_id", null: false
    t.integer "size_id",     null: false
    t.index ["clothing_id", "size_id"], name: "index_clothing_sizes_on_clothing_id_and_size_id", unique: true, using: :btree
    t.index ["size_id"], name: "index_clothing_sizes_on_size_id", using: :btree
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
    t.integer  "weight",                               null: false
    t.string   "extension",        default: ""
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

  create_table "reserved_designs", force: :cascade do |t|
    t.string   "artist",     null: false
    t.string   "snippet",    null: false
    t.integer  "design_sku", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["artist", "snippet"], name: "index_reserved_designs_on_artist_and_snippet", unique: true, using: :btree
  end

  create_table "royalties", force: :cascade do |t|
    t.string   "code",       null: false
    t.string   "league",     null: false
    t.decimal  "percentage", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_royalties_on_code", unique: true, using: :btree
    t.index ["league"], name: "index_royalties_on_league", unique: true, using: :btree
  end

  create_table "sales_channels", force: :cascade do |t|
    t.string   "name",       null: false
    t.string   "sku",        null: false
    t.decimal  "percentage", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_sales_channels_on_name", unique: true, using: :btree
    t.index ["sku"], name: "index_sales_channels_on_sku", unique: true, using: :btree
  end

  create_table "sizes", force: :cascade do |t|
    t.string   "name",                       null: false
    t.string   "sku",                        null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.boolean  "is_kids",    default: false, null: false
    t.integer  "ordinal"
    t.index ["is_kids", "ordinal"], name: "index_sizes_on_is_kids_and_ordinal", using: :btree
    t.index ["name"], name: "index_sizes_on_name", unique: true, using: :btree
  end

  create_table "tags", force: :cascade do |t|
    t.text     "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_tags_on_name", unique: true, using: :btree
  end

  create_table "team_player_designs", force: :cascade do |t|
    t.integer  "team_player_id",             null: false
    t.string   "artist",                     null: false
    t.string   "name",                       null: false
    t.integer  "sku",            default: 1, null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.index ["team_player_id", "artist", "name"], name: "team_player_lookup", unique: true, using: :btree
    t.index ["team_player_id", "sku"], name: "index_team_player_designs_on_team_player_id_and_sku", unique: true, using: :btree
  end

  create_table "team_players", force: :cascade do |t|
    t.integer  "team_id",                    null: false
    t.string   "player",                     null: false
    t.string   "sku",        default: "001", null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.index ["team_id", "player"], name: "index_team_players_on_team_id_and_player", unique: true, using: :btree
    t.index ["team_id", "sku"], name: "index_team_players_on_team_id_and_sku", unique: true, using: :btree
  end

  create_table "teams", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.string   "league"
    t.string   "city"
    t.decimal  "royalty",    default: "0.0"
    t.index ["league"], name: "index_teams_on_league", using: :btree
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
