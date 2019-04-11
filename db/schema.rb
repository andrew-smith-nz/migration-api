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

ActiveRecord::Schema.define(version: 2019_04_11_204707) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "brand_abbreviations", force: :cascade do |t|
    t.integer "brand_id"
    t.string "source"
    t.string "abbreviation"
  end

  create_table "brands", force: :cascade do |t|
    t.string "name"
  end

  create_table "ingredient_names", force: :cascade do |t|
    t.string "name"
    t.string "display_name"
    t.string "tagless_name"
  end

  create_table "ingredient_names_product_tags", id: :bigint, default: -> { "nextval('ingredient_name_product_tags_id_seq'::regclass)" }, force: :cascade do |t|
    t.integer "ingredient_name_id"
    t.integer "product_tag_id"
  end

  create_table "ingredient_type_abbreviations", force: :cascade do |t|
    t.string "word"
    t.string "abbreviation"
  end

  create_table "notation_replacements", force: :cascade do |t|
    t.string "to_replace"
    t.string "replace_with"
    t.integer "execution_order"
  end

  create_table "nutritional_source_name_product_tags", force: :cascade do |t|
    t.integer "nutritional_source_name_id"
    t.integer "product_tag_id"
  end

  create_table "nutritional_source_names", force: :cascade do |t|
    t.string "name"
    t.string "tagless_name"
  end

  create_table "nutritional_source_names_product_tags", force: :cascade do |t|
    t.integer "nutritional_source_name_id"
    t.integer "product_tag_id"
  end

  create_table "pack_sizes", force: :cascade do |t|
    t.string "pack_size"
    t.string "description"
  end

  create_table "product_name_product_tags", force: :cascade do |t|
    t.integer "product_name_id"
    t.integer "product_tag_id"
  end

  create_table "product_names", force: :cascade do |t|
    t.string "name"
    t.string "tagless_name"
  end

  create_table "product_names_product_tags", force: :cascade do |t|
    t.integer "product_name_id"
    t.integer "product_tag_id"
  end

  create_table "product_tag_aliases", id: :bigint, default: -> { "nextval('product_tag_alias_id_seq'::regclass)" }, force: :cascade do |t|
    t.integer "product_tag_id"
    t.string "alias"
  end

  create_table "product_tag_groups", force: :cascade do |t|
    t.string "name"
  end

  create_table "product_tags", force: :cascade do |t|
    t.string "name"
    t.integer "product_tag_group_id"
  end

  create_table "synonyms", force: :cascade do |t|
    t.string "word"
    t.string "synonym"
  end

  create_table "unit_abbreviations", force: :cascade do |t|
    t.string "abbreviation"
    t.string "unit"
    t.integer "execution_order"
  end

end
