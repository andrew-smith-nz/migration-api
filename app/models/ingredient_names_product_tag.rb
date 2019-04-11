class IngredientNamesProductTag < ActiveRecord::Base
  belongs_to :ingredient_name
  belongs_to :product_tag
end