Rails.application.routes.draw do
  root to: 'questions#index'

  resources :questions do
    resources :answers, only: %i[show new create], shallow: true
  end
end
