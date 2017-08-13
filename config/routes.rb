Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  root to: "routes#search"
  get 'index', to: 'routes#search'
  get 'index', to: 'routes#search'
  post 'search', to: 'routes#search_results'
end
