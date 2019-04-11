Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :product_name_parsing do
    collection do
      get "tag/:tag", to: "product_name_parsing#tag"
      get "refresh_ingredient_tags", to: "product_name_parsing#refresh_ingredient_tags"
    end
  end
  resources :pack_size_parsing
  resources :brand_parsing do
    collection do
      get "search"
    end
  end
  resources :ingredient

  namespace :api do
    namespace :v1 do
      post 'interpret_pack_size' => 'pack_size#interpret'
    end
  end
end
