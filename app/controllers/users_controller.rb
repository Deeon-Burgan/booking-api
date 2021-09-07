class UsersController < ApplicationController

    skip_before_action :verify_authenticity_token

    def login
        @user = User.find_by(email: params[:email])
        if @user && @user.authenticate(params[:password])
            token = encode_token({user_id: @user.id})
            render json: { token: token}, status: 200
        else
            render json: { error: "Invalid email or password" }, status: 401
        end
    end

    def create
        @user = User.new(user_params)
        if @user.save!
            render json: {user: @user}, status: :created
        else
            render json: @user.errors, status: :unprocessable_entity
        end
    end

    private 

    def user_params
        params.require(:user).permit(:email, :name, :password, :password_confirmation)
    end
end
