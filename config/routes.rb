Rails.application.routes.draw do
  devise_for :users, only: []
  as :user do
    get "login", to: "devise/sessions#new", as: :new_user_session
    post "login", to: "devise/sessions#create", as: :user_session
    get "logout", to: "devise/sessions#destroy"
    scope :register do
      get "/", to: "auth/registrations#new", as: :new_user_registration
      post "/", to: "auth/registrations#create", as: :user_registration
      get "confirm", to: "auth/confirmations#new", as: :user_confirmation
      post "confirm/user", to: "auth/confirmations#create"
      get "confirm/:user_id", to: "auth/confirmations#show", as: :confirmation
      get "password(/user(.:format))", to: "auth/passwords#new", as: :new_user_password
      get "password/:reset_password_token", to: "auth/passwords#edit", as: :edit_user_password
      post "password/:user_id", to: "auth/passwords#create", as: :password
      get "unlock", to: "auth/unlocks#new", as: :new_user_unlock
    end
  end

  namespace :api do
    namespace :v1 do
      resources :things do
        get 'measurements(.:format)' => 'things#get_measurements'
        post 'measurements' => 'things#add_measurement'
        get 'reset_api_key' => 'things#reset_api_key'
      end
    end
  end

  root "dashboard#index"
end