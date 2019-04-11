class ProductNamesProductTag < ActiveRecord::Base
  belongs_to :product_name
  belongs_to :product_tag
end