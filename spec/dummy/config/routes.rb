# frozen_string_literal: true

Dummy::Application.routes.draw do
  resources :images, only: [:index]
end
