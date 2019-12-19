class AuthorizeApiRequest
	prepend SimpleCommand
	attr_accessor :headers

	def initialize(headers={})
		@headers = headers
	end

	def call
		user
	end

	private

	def user
		if decode_auth_token
			User.find(decode_auth_token[:user_id]) 
		else
			errors.add(:token, 'Missing Token')
		end
	end

	def decode_auth_token
		JsonWebToken.decode(http_auth_header)
	end

	def http_auth_header
    if headers['Authorization'].present?
      return headers['Authorization'].split(' ').last
    else
    	errors.add(:token, 'Missing token')
    end
    nil
  end
end	