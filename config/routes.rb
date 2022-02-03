Rails.application.routes.draw do
  root to: 'questions#index'

  devise_for :users

  resources :questions do
    resources :answers, only: %i[show new create destroy], shallow: true
  end
end
