Rails.application.routes.draw do
  resources :images, only: [:index]
end
