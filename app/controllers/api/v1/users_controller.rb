class Api::V1::UsersController < ApplicationController

    before_action :authorized, only: [:get_user] #from application controller, token verification

    def index
        @users = User.all

        render json: @users, except: [:password_digest]
    end

    #for debugging purposes
    def create
        @user = User.create(user_params)

        if @user.valid?
            token = encode_token({user_id: @user.id})
            render json: {token: token}, status: :created
        else
            render json: {error: @user.errors.full_messages}
        end
    end 

    #authenticate
    def login

        @user = User.find_by(username: params[:user][:username])

        if @user && @user.authenticate(params[:user][:password])

            token = encode_token({userid: @user.id})
            render json: { token: token, success: true}, status: :ok
        else
            render json: {success: false, message: :unauthorized}, status: :unauthorized
        end

    end

    #authorization
    def get_user

        if !@user
            render status: :not_found
        end

        render json: {first_name: @user.first_name, last_name: @user.last_name, email: @user.email}
    end

    private

    def user_params
        params.require(:user).permit(:username, :password, :password_confirmation, :email, :first_name, :last_name)
    end
end
