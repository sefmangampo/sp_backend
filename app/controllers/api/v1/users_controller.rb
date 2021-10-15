class Api::V1::UsersController < ApplicationController

    before_action :authorized, only: [:get_user] #from application controller, token verification

    #for debugging purposes
    def create
        @user = User.create(user_params)

        if @user.valid?
            token = encode_token({user_id: @user.id})
            render json: {token: token}
        else
            render json: {error: 'Invalid username or password'}
        end
    end 

    #authenticate
    def login

        @user = User.find_by(username: params[:username])

        if @user && @user.authenticate(params[:password])
            token = encode_token({userid: @user.id})
            render json: { token: token, success: true}, status: :ok
        else
            render json: {success: false, message: :unauthorized}, status: :unauthorized
        end

    end

    #authorization
    def get_user
        render json: {first_name: @user.first_name, last_name: @user.last_name, email: @user.email}
    end

    private

    def user_params
        params.permit(:username, :password, :password_confirmation, :email, :first_name, :last_name)
    end
end
