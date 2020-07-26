Rails.application.routes.draw do

  scope '/api', format: :json do
    resources :users, only: [:create, :update] do
      post :exchange, on: :member
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
