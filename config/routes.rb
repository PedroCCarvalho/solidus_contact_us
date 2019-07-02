# frozen_string_literal: true

Spree::Core::Engine.routes.draw do
  resources :contacts, controller: 'contact_us/contacts', only: [:new, :create]
  get 'contact-us', to: 'contact_us/contacts#new', as: :contact_us
end
