module Api
  module V1
    class BooksTransactionsController < ApplicationController
      def index
        params[:q] ||= {}
        params[:q][:user_id_eq] = params[:user_id] if params[:user_id].present?
        @books_transactions = BooksTransaction.ransack(params[:q]).result
        render json: @books_transactions
      end

      def show
        @books_transaction = BooksTransaction.find(params[:id])
        render json: @books_transaction
      end

    end
  end
end
