class ProductNameParsingController < ApplicationController
  #include ProductNameParser

  def index
    @tag_counts = ProductTag.all.map{|t| {tag: t, count: 0}}
    IngredientName.all.includes(:product_tags).each do |ingredient|
      ingredient.product_tags.each do |tag|
        tag_count = @tag_counts.find{|c| c[:tag].name == tag.name}
        tag_count[:count] = tag_count[:count] + 1
      end
    end
    @tag_counts.sort_by{|a| a[:tag].product_tag_group.name}
    render
  end

  def tag
    #@words = IngredientName.where("name ilike ?", "%" + params[:word] + "%").select(:name).order(:name)
    @names = IngredientName.with_tag(params[:tag]).includes(:product_tags)
    render "tag"
  end

  def refresh_ingredient_tags
    tags = ProductTag.all.to_a
    aliases = ProductTagAlias.all.to_a
    IngredientNamesProductTag.delete_all
    IngredientName.includes(:product_tags).all.each do |ingredient|
      parts = ingredient.name.downcase.split(/[. ,\/]/).reject { |s| s.blank? }
      unused_parts = parts.dup
      parts.each do |part|
        tag_name = aliases.find{|a| a.alias.downcase == part}&.product_tag&.name&.downcase || part
        tag = tags.select{|t| t.name.downcase == tag_name }
        if tag.present?
          ingredient.product_tags << tag
          unused_parts.reject!{|s| s == part}
        end
      end
      ingredient.tagless_name = unused_parts.join(' ')
      ingredient.save!
    end
    render :inline => "<h1>Done</h1>"
  end
end