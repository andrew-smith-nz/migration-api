class CreateTempTagTables < ActiveRecord::Migration[5.2]
  def change
    create_table :ingredient_names_product_tags do |t|
      t.integer :ingredient_name_id
      t.integer :product_tag_id
    end

    create_table :product_names_product_tags do |t|
      t.integer :product_name_id
      t.integer :product_tag_id
    end

    create_table :nutritional_source_names_product_tags do |t|
      t.integer :nutritional_source_name_id
      t.integer :product_tag_id
    end
  end
end
