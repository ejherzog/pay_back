Rails.application.routes.draw do
  root 'welcome#index'

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  resources :users, except: :index
  resources :groups
  resources :expenses, except: :new

  get '/expenses/new/:group_id', to: 'expenses#new'
  get '/users/:id/add', to: 'groups#add_users'
  post '/groups/:id/add_user(/:user_id)', to: 'groups#add_user'
  post '/expenses/:id/mark_paid/:user_id', to: 'expenses#mark_paid'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
