Rails.application.routes.draw do
  resources :apps
  root to: 'apps#index'
end
