Rails.application.routes.draw do
  devise_for :users
  resources :questions do
    resources :answers, shallow: true, only: [:create, :update, :destroy] do
      patch :choose_the_best, on: :member
    end
  end

  resources :attachments, only: [:destroy]
  resources :links, only: [:destroy]
  resources :badges, only: [:index]

  root to: 'questions#index'
end
