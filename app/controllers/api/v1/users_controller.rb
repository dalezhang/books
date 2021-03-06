module Api
  module V1
    class UsersController < ApplicationController
      def create
        @user = User.new(user_params)
        if @user.valid?
          @user.save
          render json: @user
        else
          render json: @user.errors, status: 422
        end
      end

      def show
        @user = User.find(params[:id])
        render json: @user
      end

      def recharge
        service = RechargeService.new
        if params[:amount].present?
          user_amount_transaction = service.recharge(user.id, params[:amount].to_i)
          render json: user_amount_transaction
        else
          raise BooksException, 'params amount is pequired!'
        end
      end

      def borrow_book
        service = BooksService.new
        books_transaction = service.borrow(user.id, book.id)
        render json: books_transaction
      end

      def return_book
        service = BooksService.new
        if params[:cost].present?
          books_transaction = service.return(user.id, book.id, params[:cost])
          render json: books_transaction
        else
          raise BooksException, 'params cost is pequired!'
        end
      end

      private

      def user_params
        raise BooksException, 'params users is require!' unless params[:users].present?

        params.require(:users).permit(
          :name,
          :email
        )
      end

      def user
        @user = User.find(params[:id])
      end

      def book
        raise BooksException, 'params book_id is require!' unless params[:book_id].present?

        @book = Book.find_by_id(params[:book_id])
        raise BooksException, "can`t find book by params book_id #{params[:book_id]}" unless @book.present?

        @book
      end
    end
  end
end
