######################################################################
# Class name: WelcomeController
# File name: welcome_controller.rb
# Description: Represents the initial page of the application
######################################################################

class WelcomeController < ApplicationController
    # Description: Searches for an Enterprise from the database
    # according to the information provided by the user.
    # Parameters: none.
    # Return: none.
    def index
        # query is the information provided, by the user, to search.
        # cnpj is the Brazil's National Register of Legal Entities.
        @SEARCH = Enterprise.search( params[:query] )
        assert_object_is_not_null( @SEARCH )
        @ENTERPRISES = @SEARCH.result
        assert_object_is_not_null( @ENTERPRISES )
    end
end
