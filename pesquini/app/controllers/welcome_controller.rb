######################################################################
# Class name: WelcomeController
# File name: welcome_controller.rb
# Description: Represents the initial page of the application
######################################################################

class WelcomeController < ApplicationController
    # Description: Searches for an Enterprise from the database
    # according to the information provided by the user.
    # Parameters: none.
    # Return: enterprises.
    def index
        params[:q][:cnpj_eq] = params[:q][:corporate_name_cont] unless params[:q].nil?
        @search = Enterprise.search( params[:q].try( :merge, m: 'or' ) )
        assert_object_is_not_null( @search )
        @ENTERPRISES = @search.result
        assert_object_is_not_null( @ENTERPRISES )
    end
end
