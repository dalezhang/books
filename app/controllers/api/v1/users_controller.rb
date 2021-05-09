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
      private

      def user_params
        raise BooksException, 'params users is require!'  unless params[:users].present?
        params.require(:users).permit(
          :name,
          :email,
        )
      end
    end
  end
end
