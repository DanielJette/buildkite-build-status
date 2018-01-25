Rails.application.routes.draw do
  get 'welcome/index'

  resources :status

  root 'welcome#index'
end
