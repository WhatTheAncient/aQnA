Rails.application.routes.draw do
  root to: 'questions#index'

  devise_for :users

  concern :linkable do
    delete :destroy_link, on: :member
  end

  concern :fileable do
    delete :destroy_file, on: :member
  end

  concern :votable do
    post :vote, on: :member
    delete :unvote, on: :member
  end

  resources :questions, concerns: [:linkable, :fileable, :votable] do
    patch :choose_best_answer, on: :member
    resources :answers, concerns: [:linkable, :fileable, :votable], shallow: true, only: %i[create update destroy]
  end

  resources :rewards, only: %i[index]
end
