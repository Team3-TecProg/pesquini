######################################################################
# Class name: ApplicationController
# File name: application_controller.rb
# Description: Default parent controller, all others controllers
# inherit it
######################################################################

class ApplicationController < ActionController::Base
    include SessionsHelper
    include ApplicationHelper

    # Prevent CSRF attacks by raising an exception.
    # For APIs, you may want to use :null_session instead.
    protect_from_forgery with: :exception

    rescue_from ActiveRecord::RecordNotFound, :with => :render_not_found
    rescue_from ActionController::RoutingError, :with => :render_not_found

    # Description: Set default error message for routing errors in controllers.
    # Parameters: none.
    # Return: none.
    def raise_not_found!
        raise ActionController::RoutingError.new("No route matches \
        #{params[:unmatched_route]}")
    end

    # Description: Set default error message that was called when an error
    # occured rendering template.
    # Parameters: none.
    # Return: none.
    def render_not_found
        respond_to do |f|
            f.html{ render :template => "errors/404", :status => 404 }
        end
    end
end
