Rails.application.routes.draw do
   #get "layouts#original"
   #get "content/gold"
   #get "content/platinum"
  # mount Payola::Engine => '/payola', as: :payola
   #root to: 'visitors#index'
  # get 'products/:id', to: 'products#show', :as => :products
  # devise_for :users, :controllers => { :registrations => 'registrations' }
  # devise_scope :user do
  #   put 'change_plan', :to => 'registrations#change_plan'
  # end
  # resources :users

  root 'dashboard#index'

  get 'login' => 'visitors#login'

  namespace :api do
    namespace :v1 do
      resources :things do
        get 'measurements(.:format)' => 'things#get_measurements'
        post 'measurements' => 'things#add_measurement'
      end
    end
  end
end
