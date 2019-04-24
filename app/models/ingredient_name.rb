class IngredientName < ActiveRecord::Base
  has_many :ingredient_names_product_tags, dependent: :delete_all
  has_many :product_tags, through: :ingredient_names_product_tags

  attr_accessor :match_construct

  scope :with_tag, -> (tag) { left_joins(:product_tags).where('product_tags.name = ?', tag) }
  scope :with_all_tags, -> (tags, leeway = 0) { left_joins(:product_tags).group(:id).where(product_tags: {name: tags}).having("COUNT(product_tags.id) >= ?", tags.count - leeway) }

  def get_tag_percent_match match
    matching_tags = 0
    product_tags.each do |tag|
      matching_tags = matching_tags + 1 if (match.product_tags.include?(tag))
    end
    total_tags = product_tags.map{|tag| tag.name}.concat(match.product_tags.map{|tag| tag.name}).uniq
    return (matching_tags.to_f / total_tags.count.to_f * 100).round(0)
  end

  def get_name_percent_match match
    this_name = tagless_name
    match_name = match.tagless_name
    if this_name.strip.length > 0 && match_name.include?(name)
      return 100 - (match_name.length - this_name.length) / match_name.length
    end
    if match_name.strip.length > 0 && this_name.include?(match_name)
      return 100 - (this_name.length - match_name.length) / this_name.length
    end
    l_distance = DamerauLevenshtein.distance(this_name, match_name, 1, 99)

    return 100 if l_distance == 0.0 #exact match
    name_length = (this_name.length > match_name.length ? this_name.length : match_name.length)
    return 100 - (100 * l_distance / name_length).round
  end

  def get_match_color percentage
    if percentage > 90
      return '#66CC00'
    elsif percentage > 75
      return '#CCFF99'
    elsif percentage > 50
      return '#FF8000'
    else
      return '#FF3333'
    end
  end

  def get_match_construct match
    tag_percent = get_tag_percent_match(match)
    name_percent = get_name_percent_match(match)
    final_percent = (tag_percent + name_percent) / 2
    { percent: final_percent, color: get_match_color(final_percent), tag_percent: tag_percent, name_percent: name_percent }
  end
end