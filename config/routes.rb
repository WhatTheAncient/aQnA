Rails.application.routes.draw do
  root to: 'questions#index'

  devise_for :users

  concern :votable do
    post :vote, on: :member
    delete :unvote, on: :member
  end

  resources :questions, concerns: [:votable] do
    patch :choose_best_answer, on: :member
    resources :answers, concerns: [:votable], shallow: true, only: %i[create update destroy]
  end

  resources :links, only: %i[destroy]
  resources :files, only: %i[destroy]
  resources :rewards, only: %i[index]
  resources :comments, only: %i[create]

  mount ActionCable.server => '/cable'
end
