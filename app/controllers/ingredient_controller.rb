class IngredientController < ApplicationController
  def show
    @ingredient = IngredientName.includes(:product_tags).find(params[:id])
    @similar_ingredients = IngredientName.with_all_tags(@ingredient.product_tags.map{|t| t.name}.to_a, 1).where.not(id: @ingredient.id)
    @similar_ingredients.each do |ing|
      ing.match_construct = @ingredient.get_match_construct ing
    end
    @similar_ingredients = @similar_ingredients.sort{|a, b| b.match_construct[:percent] <=> a.match_construct[:percent]}.take(10)
    @similar_nutritional_sources = NutritionalSourceName.with_all_tags(@ingredient.product_tags.map{|t| t.name}.to_a)
    @similar_nutritional_sources.each do |ing|
      ing.match_construct = @ingredient.get_match_construct ing
    end
    @similar_nutritional_sources = @similar_nutritional_sources.sort{|a, b| b.match_construct[:percent] <=> a.match_construct[:percent]}.take(10)
    @similar_products = ProductName.with_all_tags(@ingredient.product_tags.map{|t| t.name}.to_a)
    @similar_products.each do |ing|
      ing.match_construct = @ingredient.get_match_construct ing
    end
    @similar_products = @similar_products.sort{|a, b| b.match_construct[:percent] <=> a.match_construct[:percent]}.take(10)
    render
  end
end