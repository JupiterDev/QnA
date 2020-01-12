Rails.application.routes.draw do
  devise_for :users

  concern :votable do
    member do
      post :vote_up, :vote_down
    end
  end

  resources :questions, concerns: :votable do
    resources :answers, concerns: :votable, shallow: true, only: [:create, :update, :destroy] do
      patch :choose_the_best, on: :member
    end
  end

  resources :attachments, only: [:destroy]
  resources :links, only: [:destroy]
  resources :badges, only: [:index]

  root to: 'questions#index'
end
