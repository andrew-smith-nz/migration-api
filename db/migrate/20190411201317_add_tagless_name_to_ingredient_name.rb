class AddTaglessNameToIngredientName < ActiveRecord::Migration[5.2]
  def change
    add_column :ingredient_names, :tagless_name, :string
  end
end
