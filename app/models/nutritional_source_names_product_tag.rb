class NutritionalSourceNamesProductTag < ActiveRecord::Base
  belongs_to :nutritional_source_name
  belongs_to :product_tag
end