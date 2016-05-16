######################################################################
# Class name: EnterprisesController
# File name: enterprises_controller.rb
# Description: Controller for the Enterprises model, which holds methods to
# link it to the Enterprise views.
######################################################################

class EnterprisesController < ApplicationController

    # Description: Searchs for a enterprise according the params sent by user,
    # once did it, return a set of enterprises with pagination.
    # Parameters: none.
    # Return: @enterprises.
    def index
        page_enterprise = 10
        # q is Identifier enterprise.
        if params[:query].nil?
            @search = Enterprise.search( params[:query])
            assert_object_is_not_null ( @search )
            @ENTERPRISES = Enterprise.paginate(:page => params[:page], :per_page => page_enterprise )
            assert_object_is_not_null ( @entreprises )
        else
            # cnpj is National Register of Legal Entities.
            params[:query][:cnpj_eq] = params[:query][:corporate_name_cont]
            @search = Enterprise.search( params[:query].try( :merge, m: 'or' ) )
            assert_object_is_not_null ( @search )
            @ENTERPRISES = @search.result.paginate( :page => params[:page],
                                                      :per_page => page_enterprise )
            assert_object_is_not_null ( @entreprises )
        end
    end

    # Description: Sets the main params for exibition of enterprises, like
    # quantity of enterprises by page and the entrepise's informations that
    # should be showed.
    # Parameters: none.
    # Return: @page_number, @enterprise, @single_sanction, @payments, @sanctions,
    # @payment_position, @position.
    def show
        @results_per_page = 10
        # Matches a given Enterprise to its position in the page index.
        page_invalid = 0
        page_valid = 1
        if ( params[:page].to_i > page_invalid )
            @page_number = params[:page].to_i - page_valid
            assert_object_is_not_null ( @page_number )
        else
            @page_number = 0
        end

        # Instance variables to be used in the Enterprise Show view.
        #Have a enterprise from the id taken.
        @enterprise = Enterprise.find( params[:id] )
        assert_object_is_not_null ( @entreprise )

        #Take a sanction from the enterprise.
        @single_sanction = Sanction.where( enterprise_id: @enterprise.id )
        assert_object_is_not_null ( @single_sanction )

        #Take payments from the enterprise an shows 10 each time.
        @payments = Payment.where( enterprise_id: @enterprise.id).paginate( :page => params[:page], :per_page => @results_per_page )
        assert_object_is_not_null ( @payments)

        #Take 10 sanctions to show in the same page.
        @sanctions = @single_sanction.paginate( :page => params[:page], :per_page => @results_per_page )
        assert_object_is_not_null ( @sanctions )

        #Take a ordened list of payments from the enterprise.
        @payment_position = enterprise_payment_position( @enterprise )
        assert_object_is_not_null ( @payment_position )

        #Take the position of enterprise in a ordened list.
        @position = Enterprise.enterprise_position( @enterprise )
        assert_object_is_not_null ( @position )
    end

    # Description: Recover the index of a specific enterprise.
    # Parameters: enterprise.
    # Return: index.
    def enterprise_payment_position( enterprise )
        enterprises_ordered_by_payments = Enterprise.featured_payments
        enterprises_ordered_by_payments.each_with_index do |organization, index|
        # Returns the position of the Enterprise, based on its payment sum
        iterator_position = 1
        if organization.payments_sum == enterprise.payments_sum
            return index + iterator_position
        else
            # Nothing to do.
        end
    end
  end
end
