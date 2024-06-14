Rails.application.routes.draw do
  get 'webhooks/receive'
  get 'users/create'
  get 'users/update'
  post '/webhook', to: 'webhooks#receive'
  get '/webhook', to: 'webhooks#receive'

    resources :users, only: [:create, :update]

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
