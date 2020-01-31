require 'sidekiq/web'

Rails.application.routes.draw do
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  use_doorkeeper
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
    resource :subscription, only: %i[create destroy]
    resources :answers, concerns: %i[votable commentable], shallow: true, only: [:create, :update, :destroy] do
      patch :choose_the_best, on: :member
    end
  end

  resources :attachments, only: [:destroy]
  resources :links, only: [:destroy]
  resources :badges, only: [:index]

  root to: 'questions#index'

  namespace :api do
    namespace :v1 do
      resources :profiles, only: [] do
        collection do
          get :me
          get :all
        end
      end

      resources :questions, only: %i[index show create update destroy], shallow: true do
        resources :answers, only: %i[index show create update destroy]
      end
    end
  end

  mount ActionCable.server => '/cable'
end
