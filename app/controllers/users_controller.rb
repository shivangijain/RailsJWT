class UsersController < ApplicationController

	skip_before_action :authorize_user, only: %i[login register]

	def register
		@user = User.create(user_params)
		if @user.save
			response = { message: 'User is successfully created '}
			render json: response, status: :created
		else
			render json: @user.errors, status: :bad
		end
	end

	def login
		authenticate user_params[:email], user_params[:password]
	end

	def test
    render json: {
          message: 'You have passed authentication and authorization test'
        }
  end

	private

	def user_params
		params.permit(:name, :email, :password)
	end

	def authenticate(email, password)
		command = AuthenticateUser.call(email, password)
		if command.success?
      render json: {
        access_token: command.result,
        message: 'Login Successful'
      }
    else
      render json: { error: command.errors }, status: :unauthorized
    end
	end
end
