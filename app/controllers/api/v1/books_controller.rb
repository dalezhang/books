module Api
  module V1
    class BooksController < ApplicationController

      def index
        @books = Book.ransack(params[:q]).result
        render json: @books
      end

      def show
        @user = User.find(params[:id])
        render json: @user
      end
    end
  end
end
