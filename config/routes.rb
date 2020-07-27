Rails.application.routes.draw do

  scope '/api', format: :json do
    resources :users, only: [:create, :update, :show] do
      member do
        post :exchange
        put :on_vacation
        put :return_vacation
      end
    end

    namespace :reports do
      get :percentage_users_on_vacation
      get :percentage_users_working

      get :avg_users_equipment
      get :total_price_equipments_on_vacation
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
