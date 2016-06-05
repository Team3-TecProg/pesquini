######################################################################
# Class name: SessionsHelper
# File name: sessions_helper.rb
# Description: Manipulates the login/logout feature of the application.
######################################################################

module SessionsHelper

    # Description: Log in the user in the application, creating an unique token
    # and saving it in a cookie.
    # Parameters: user.
    # Return: none.
    def sign_in ( user )
        remember_token = User.new_remember_token
        cookies.permanent[:remember_token] = remember_token
        user.update_attribute( :remember_token, User.digest( remember_token ) )
        self.current_user = user
    end

    # Description: Method called by the sign_in and sign_out methods. Assigns an
    # user object to an instance variable, if the user is connecting, or assigns
    # nil if the user is disconnecting.
    # Parameters: user.
    # Return: @current_user.
    def current_user= ( user )
        return @current_user = user
    end

    # Description: Verifies who is the user currently logged in the application.
    # Parameters: none.
    # Return: @current_user.
  	def current_user
        remember_token = User.digest( cookies[:remember_token] )
        @current_user ||= User.find_by( remember_token: remember_token )
        return @current_user
  	end

    # Description: Verifies if there is an user currently logged in the
    # application.
    # Parameters: none.
    # Return: boolean.
    def signed_in?
        return !current_user.nil?
  	end

    # Description: Prevents unauthorized access to some contents of the
    # application to not logged guests.
    # Parameters: none.
    # Return: none.
    def authorize
        if ( !signed_in? )
            redirect_to '/signin', alert: "Nao autorizado!"
        else
            # Nothing to do.
        end
    end

    # Description: Log out an user from the application, and erases that user's
    # token from the cookies.
    # Parameters: none.
    # Return: none.
    def sign_out
        token = User.digest( User.new_remember_token )
        current_user.update_attribute( :remember_token, token )
        cookies.delete( :remember_token )
        self.current_user = nil
    end
end
