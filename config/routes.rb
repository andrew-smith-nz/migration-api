Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :data_parsings

  namespace :api do
    namespace :v1 do
      post 'interpret_pack_size' => 'pack_size#interpret'
    end
  end
end
