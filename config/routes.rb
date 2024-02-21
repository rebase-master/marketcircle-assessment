Rails.application.routes.draw do
  root 'people#index'
  get 'edit/person/:person_id/detail', to: 'details#edit', as: :edit_person_detail
  resources :people do
    resources :details, except: [:edit]
  end
  get 'up' => 'rails/health#show', as: :rails_health_check
end
