Rails.application.routes.draw do
  root to: 'apps#index'

  resources :apps do
    resource :translations, only: %i(create edit update)
  end
end
