Rails.application.routes.draw do
  resources :products

  devise_for :users,
    defaults: {:format => :json},
    path: '',
    path_names: {
      sign_in: 'api/login',
      registration: 'api/signup'
    },
    controllers: {
      sessions: 'sessions',
      registrations: 'registrations',
      confirmations: 'confirmations'
    }
end
