######################################################################
# Class name: EnterprisesController
# File name: enterprises_controller.rb
# Description: Controller for the Enterprises model, which holds methods to
# link it to the Enterprise views.
######################################################################

class EnterprisesController < ApplicationController

    # Lists all the enterprises in the database, if the user did not provide
    # a query to search, or lists the enterprise that matches the provided query
    # otherwise.
    def index
        if params[:q].nil?
            @search = Enterprise.search( params[:q].try(:merge, m: 'or' ) )
            assert_object_is_not_null ( @search )
            @ENTERPRISES = Enterprise.paginate(:page => params[:page], :per_page => 10 )
            assert_object_is_not_null ( @entreprises )
        else
            params[:q][:cnpj_eq] = params[:q][:corporate_name_cont]
            @search = Enterprise.search( params[:q].try( :merge, m: 'or' ) )
            assert_object_is_not_null ( @search )
            @ENTERPRISES = @search.result.paginate( :page => params[:page],
                                                      :per_page => 10 )
            assert_object_is_not_null ( @entreprises )
        end
    end

    def show
        @results_per_page = 10
        # Matches a given Enterprise to its position in the page index.
        if ( params[:page].to_i > 0 )
            @page_number = params[:page].to_i - 1
            assert_object_is_not_null ( @page_number )
        else
            @page_number = 0
        end

        # Instance variables to be used in the Enterprise Show view.
        @enterprise = Enterprise.find( params[:id] )
        assert_object_is_not_null ( @entreprise )
        @collection = Sanction.where( enterprise_id: @enterprise.id )
        assert_object_is_not_null ( @collection )
        @payments = Payment.where( enterprise_id: @enterprise.id).paginate( :page => params[:page], :per_page => @results_per_page )
        assert_object_is_not_null ( @payments)
        @sanctions = @collection.paginate( :page => params[:page], :per_page => @results_per_page )
        assert_object_is_not_null ( @sanctions )
        @payment_position = enterprise_payment_position( @enterprise )
        assert_object_is_not_null ( @payment_position )
        @position = Enterprise.enterprise_position( @enterprise )
        assert_object_is_not_null ( @position )
    end

    def enterprise_payment_position(enterprise)
        enterprises_ordered_by_payments = Enterprise.featured_payments
        enterprises_ordered_by_payments.each_with_index do |organization, index|
        # Returns the position of the Enterprise, based on its payment sum
        if organization.payments_sum == enterprise.payments_sum
            return index + 1
        else
            # Nothing to do.
        end
    end
  end
end
