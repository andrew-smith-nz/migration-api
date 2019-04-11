class AddProductTags < ActiveRecord::Migration[5.2]
  def change
    create_table :product_tags do |t|
      t.string :name
      t.integer :product_tag_group_id
    end

    create_table :product_tag_groups do |t|
      t.string :name
    end

    create_table :product_tag_aliases do |t|
      t.integer :product_tag_id
      t.string :alias
    end
  end
end