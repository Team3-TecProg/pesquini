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
end
