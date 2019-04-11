class IngredientController < ApplicationController
  def show
    @ingredient = IngredientName.includes(:product_tags).find(params[:id])
    @similar_ingredients = IngredientName.with_all_tags(@ingredient.product_tags.map{|t| t.name}.to_a).where.not(id: @ingredient.id)
    render
  end
end