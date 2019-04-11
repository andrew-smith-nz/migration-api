class IngredientName < ActiveRecord::Base
  has_many :ingredient_names_product_tags, dependent: :delete_all
  has_many :product_tags, through: :ingredient_names_product_tags

  scope :with_tag, -> (tag) { left_joins(:product_tags).where('product_tags.name = ?', tag) }
  scope :with_all_tags, -> (tags, leeway = 0) { left_joins(:product_tags).group(:id).where(product_tags: {name: tags}).having("COUNT(product_tags.id) >= ?", tags.count - leeway) }

end