Rails.application.routes.draw do

  scope '/api', format: :json do
    resources :users, only: [:create, :update, :show] do
      member do
        post :exchange
        put :on_vacation
        put :return_vacation
      end
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
