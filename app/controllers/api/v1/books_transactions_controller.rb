module Api
  module V1
    class BooksTransactonsController < ApplicationController
      def index
        params[:q][:user_id_eq] = params[:user_id] if params[:user_id].present?
        @books_transactions = BooksTransaction.ransack(params[:q]).result
        render json: @books_transactions.page(page).per(per_page)
      end

      def show
        @books_transaction = BooksTransaction.find(params[:id])
        render json: @books_transaction
      end
    end
  end
end
