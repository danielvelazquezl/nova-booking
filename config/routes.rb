Rails.application.routes.draw do

  get 'comments/save'
  # defaults to dashboard
  root :to => redirect('/welcome/index')

  get 'welcome/index'
  get 'welcome/results'
  get 'welcome/resources'

  devise_for :users do
    get '/users/sign_out' => 'devise/sessions#destroy'
  end
  devise_scope :user do
    get '/users', to: 'devise/registrations#new'
    get '/users/password', to: 'devise/passwords#new'
  end

  resources :cities
  resources :departaments
  resources :owners do
    member do
      get :contact
    end
  end

  resources :offers
  resources :estates do
    collection do
      get 'estates_visited', :to => 'estates#estates_visited', :as => 'visited'
      get :new_room
      post :unsuscribe_estate
    end
  end

  delete 'estates/:id/remove_image', to: 'estates#remove_image', :as => 'remove_image_estate'
  get 'rooms/:id', to: 'estates#room', :as => 'room_estate'
  get 'estates/:id/show_detail', :to => 'estates#show_detail', :as => 'show_detail_estate'
  get 'estates/:id/show_visited', :to => 'estates#show_visited', :as => 'show_visited_estate'

  get 'bookings/show_detail/:id', :to => 'bookings#show_detail', :as => 'show_detail_booking'
  get 'bookings/index_user', :to => 'bookings#index_user', :as => 'index_user'
  get 'bookings/index_owner', :to => 'bookings#index_owner', :as => 'index_owner'
  get 'bookings/cancel/:id', :to => 'bookings#cancel', :as => 'cancel'

  resources :users, only: [:show, :edit, :update]
  resources :rooms
  resources :facilities, except: :show
  resources :bookings, except: [:edit, :update, :delete, :index] do
    collection do
      get :confirmation
      post :cancel_my_booking  # for users
      post :cancel_booking     # for owners
    end
  end
  resources :comments, only: [] do
    collection do
      post :save
      get :index
    end
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # api routes
  get '/api/i18n/:locale' => 'api#i18n'

end
