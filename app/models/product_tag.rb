class ProductTag < ActiveRecord::Base
  belongs_to :product_tag_group
  has_many :product_tag_aliases
end