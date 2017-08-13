Rails.application.routes.draw do
  root to: "routes#search"
  get 'index', to: 'routes#search'
  get 'index', to: 'routes#search'
  post 'search', to: 'routes#search_results'
end
