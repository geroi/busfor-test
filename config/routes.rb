Rails.application.routes.draw do
  root to: "routes#search"
  get 'index', to: 'routes#search'
end
