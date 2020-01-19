Rails.application.routes.draw do
  devise_for :users

  concern :votable do
    member do
      post :vote_up, :vote_down
      delete :cancel_vote
    end
  end

  concern :commentable do
    resources :comments, only: :create, shallow: true
  end

  resources :questions, concerns: %i[votable commentable] do
    resources :answers, concerns: %i[votable commentable], shallow: true, only: [:create, :update, :destroy] do
      patch :choose_the_best, on: :member
    end
  end

  resources :attachments, only: [:destroy]
  resources :links, only: [:destroy]
  resources :badges, only: [:index]

  root to: 'questions#index'

  # mount ActionCable.server => '/cable'
end
