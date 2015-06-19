Rails.application.routes.draw do
  root "tasks#home"

  resources :tasks, only: [:create] do
    collection do
      get 'home'
    end

    member do 
    end
  end
end
