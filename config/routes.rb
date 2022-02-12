Rails.application.routes.draw do
  root to: 'questions#index'

  devise_for :users

  resources :questions do
    patch "choose_best_answer", to: "questions#choose_best_answer", on: :member
    resources :answers, shallow: true, only: %i[create update destroy]
  end

  resources :files, only: %i[destroy]
end
