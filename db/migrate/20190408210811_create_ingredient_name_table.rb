class CreateIngredientNameTable < ActiveRecord::Migration[5.2]
  def change
    create_table :ingredient_names do |t|
      t.string :name
      t.string :display_name
    end

    create_table :ingredient_type_abbreviations do |t|
      t.string :word
      t.string :abbreviation
    end
  end
end
