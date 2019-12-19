Rails.application.routes.draw do
  devise_for :users
  resources :questions do
    resources :answers, shallow: true, only: [:create, :update, :destroy] do
      patch :choose_the_best, on: :member
    end
  end

  root to: 'questions#index'
end
