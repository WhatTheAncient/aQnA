require 'sidekiq/web'

Rails.application.routes.draw do
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  use_doorkeeper

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
  resource :subscriptions, only: %i[create destroy]

  mount ActionCable.server => '/cable'

  namespace :api do
    namespace :v1 do
      resources :profiles, only: [] do
        get :me, on: :collection
        get :other, on: :collection
      end

      resources :questions, only: %i[index show create update destroy] do
        resources :answers, shallow: true, only: %i[index show create update destroy]
      end
    end
  end
end
