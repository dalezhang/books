Rails.application.routes.draw do
  namespace :api, path: '/', defaults: { format: 'json' } do
    namespace :v1 do
      resources :users, only: %i(create show) do
        post :borrow_book, :return_book, :recharge,  on: :member
      end
      resources :books, only: %i(index show) do
        get :income, on: :member
      end
      resources :books_transactions, only: %i(index show)
    end
  end

end
