Rails.application.routes.draw do
  root 'people#index'
  resources :people do
    resources :details
  end
  get 'up' => 'rails/health#show', as: :rails_health_check
end
