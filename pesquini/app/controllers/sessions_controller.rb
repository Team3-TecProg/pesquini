######################################################################
# Class name: SessionsController
# File name: sessions_controller.rb
# Description: class that implements default REST actions to User sessions.
######################################################################

class SessionsController < ApplicationController
    def new
    end

    def create
        # Searches for a user that matches the provided login information.
        login = params[:session][:login].downcase
        assert_object_is_not_null ( login )
        password = params[:session][:password]
        assert_object_is_not_null ( password )
        user = User.find_by(login: login)
        assert_object_is_not_null ( user )
        # Verifies if the provided password is correct.
        if ( user && user.authenticate( password ) )
            sign_in user
            redirect_to root_path
        else
            flash[:error] = "Login ou senha invalidos!"
            render :new
        end
    end

    def destroy
        # Finishes the user session.
        if signed_in?
            sign_out
            redirect_to root_path
        else
            # Nothing to do.
        end
    end
end
