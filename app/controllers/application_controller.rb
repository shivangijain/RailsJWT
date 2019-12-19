class ApplicationController < ActionController::API
	before_action :authorize_user
	include ExceptionHandler

	private

	def authorize_user
		@current_user = AuthorizeApiRequest.call(request.headers).result
		render json: {error: 'Not Authorized'}, status: 401 unless @current_user
	end
end
