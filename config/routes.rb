Rails.application.routes.draw do
  namespace :api, path: '/', defaults: { format: 'json' } do
    namespace :v1 do
      resources :users, only: %i(create show)
      resources :books, only: %i(index show)
      resources :books_transactions, only: %i(index show create)
    end
  end

  namespace :admin, defaults: { format: 'json' } do
    namespace :v1 do
      resources :users, only: [:index, :show, :update]
    end
  end
end
