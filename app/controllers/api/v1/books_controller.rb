module Api
  module V1
    class BooksController < ApplicationController
      def index
        params[:q] ||= {}
        @books = Book.ransack(params[:q]).result
        render json: @books
      end

      def show
        @user = User.find(params[:id])
        render json: @user
      end

      def income
        from = params[:from] || Time.now - 1.day
        from = from.to_time.beginning_of_day
        to = params[:to] || Time.now
        to = to.to_time.end_of_day
        params[:q] ||= {}
        params[:q][:book_id_eq] = params[:id]
        params[:q][:option_eq] = BooksTransaction.options["back"]
        params[:q][:status_eq] = BooksTransaction.statuses["returned"]
        params[:q][:created_at_gt] = from.to_s
        params[:q][:created_at_lt] = to.to_s
        books_transaction_ids = BooksTransaction.ransack(params[:q]).result.pluck(:id)
        @user_amount_transactions = UserAmountTransaction.where(
          books_transaction_id: books_transaction_ids,
        )
        hash = {
          book_id: params[:id],
          from: from,
          to: to,
          total_income: @user_amount_transactions.sum(:amount)
        }
        render json: hash

      end
    end
  end
end
