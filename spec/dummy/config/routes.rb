Dummy::Application.routes.draw do
  resources :images, only: [:index]
end
