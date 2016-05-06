######################################################################
# Class name: UsersController
# File name: users_controller.rb
# Description: Controller used by model User with the Users view.
######################################################################

class UsersController < ApplicationController
    # Creates a new user.
    def new
        @user = User.new
        assert_object_is_not_null( @user )
  end
 end
