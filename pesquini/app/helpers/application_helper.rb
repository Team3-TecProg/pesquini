######################################################################
# Class name: ApplicationHelper
# File name: application_helper.rb
# Description: Holds utility methods used by other classes.
######################################################################

module ApplicationHelper

    # Description: sends a flash message depending on the status of the 
    # operation.
    # Parameters: level.
    # Return: string.
    def flash_class( level )
        case level
            when :notice then "alert alert-info"
            when :success then "alert alert-success"
            when :error then "alert alert-error"
            when :alert then "alert alert-error"
        end
    end

    # Description: Aborts the system if an object should be null, but isn't.
    # Parameters: object.
    # Return: none.
    def assert_object_is_not_null( object )
        if( not object.nil? )
            # Object is not null, nothing to do.
        else
            #redirect_to assert_error_null_path
        end
    end

    # Description: Aborts the system if an object has null content.
    # Parameters: none.
    # Return: none.
    def assert_error_null
    end

    # Description: Aborts the system if an object has a type note correct
    # Parameters: none.
    # Return: none.
    def assert_error_type_of_object
    end

    # Description: Aborts the system if an object has a wrong type.
    # Parameters: type_is_correct.
    # Return: none.
    def assert_type_of_object( type_is_correct )
        if( type_is_correct )
            # Object has the expected type, nothing to do.
        else
            # redirect_to assert_error_type_of_object_path
        end
    end
end
