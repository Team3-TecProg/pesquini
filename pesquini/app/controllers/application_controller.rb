######################################################################
# Class name: ApplicationController
# File name: application_controller.rb
# Description: Default parent controller, all others controllers..
#..inherit it
######################################################################

class ApplicationController < ActionController::Base
    include SessionsHelper

    # Prevent CSRF attacks by raising an exception.
    # For APIs, you may want to use :null_session instead.
    protect_from_forgery with: :exception

    rescue_from ActiveRecord::RecordNotFound, :with => :render_not_found
    rescue_from ActionController::RoutingError, :with => :render_not_found

    # Set default error message for routing errors in controllers.
    def raise_not_found!
        raise ActionController::RoutingError.new("No route matches \
        #{params[:unmatched_route]}")
    end

    # Set default error message that was called when an error occur
    # rendering template.
    def render_not_found
        respond_to do |f|
            f.html{ render :template => "errors/404", :status => 404 }
        end
    end

    def assert_object_is_not_null( object )
        if( not object.nil? )
            # Object is not null, nothing to do
        else
            # redirect to a page
            # flash a message
        end
    end

    def assert_type_of_object( type_is_correct )
        if( type_is_correct )
            # Object has the expected type, nothing to do
        else
            # redirect to a page
            # flash a message
        end
    end
end
