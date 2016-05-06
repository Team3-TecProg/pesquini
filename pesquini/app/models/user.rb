######################################################################
# Class name: User
# File name: user.rb
# Description: Represents an User of the application
######################################################################

class User < ActiveRecord::Base
	#Validates login and password
	has_secure_password
	validates :login, length: { maximum: 50, minimum: 5 }, uniqueness: { case_sensitive: false }, allow_blank: false
	validates :password, length: { minimum: 8 }, allow_blank: false

	# Generates an unique random string for user
	def User.new_remember_token
  		secure_token = SecureRandom.urlsafe_base64
      return token
  end

	# Encrypts the parameter received
  def User.digest(token)
  		encripted_token = Digest::SHA1.hexdigest(token.to_s)
      return encripted_token
  end
end
