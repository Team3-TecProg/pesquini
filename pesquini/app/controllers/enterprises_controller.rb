######################################################################
# Class name: EnterprisesController
# File name: enterprises_controller.rb
# Description: Controller for the Enterprises model, which holds
# methods to link it to the Enterprise views.
######################################################################

class EnterprisesController < ApplicationController
    include Assertions

    # Description: Shows enterprises after they have been searched and
    # paginated.
    # Parameters: none.
    # Return: @ENTERPRISES.
    def index
        # The query symbol is the information provided by the user to perform a
        # search.
        # If exists content in params make the assignment, else nothing to do.
        if ( params[:query] )
            params[:query][:cnpj_eq] = params[:query][:corporate_name_cont]
        else
            # Nothing to do.
        end

        @SEARCH = search_for_query
        @ENTERPRISES = paginate_results( @SEARCH )
        assert_object_is_not_null ( @ENTERPRISES )
        return @ENTERPRISES
    end

    # Description: Sets the main parameters for exhibition of enterprises, like
    # quantity of enterprises by page and the enterprise's informations that
    # should be displayed.
    # Parameters: none.
    # Return: none.
    def show
        @RESULTS_PER_PAGE = 10
        # Matches a given Enterprise to its position in the page index.
        page_invalid = 0
        page_valid = 1

        if ( params[ :page ].to_i > page_invalid )
            @PAGE_NUMBER = params[ :page ].to_i - page_valid
            assert_object_is_not_null ( @PAGE_NUMBER )
        else
            @PAGE_NUMBER = 0
        end

        # Instance variables to be used in the Enterprise Show view.

        # Fetches an enterprise based on its ID.
        @ENTERPRISE = Enterprise.find( params[ :id ] )
        assert_object_is_not_null ( @ENTERPRISE )

        #Takes a sanction from the enterprise.
        single_sanction = Sanction.where( enterprise_id: @ENTERPRISE.id )
        assert_object_is_not_null ( single_sanction )

        #Takes payments from the enterprise and shows them in groups of  10.
        payment_page = { :page => params[ :page ], :per_page => @RESULTS_PER_PAGE }
        enterprise = { enterprise_id: @ENTERPRISE.id }
        @PAYMENTS = Payment.where( enterprise ).paginate( payment_page )
        assert_object_is_not_null ( @PAYMENTS)

        #Takes 10 sanctions to show in the same page.
        sanction_page = { :page => params[ :page ], :per_page => @RESULTS_PER_PAGE }
        @SANCTIONS = single_sanction.paginate( sanction_page )
        assert_object_is_not_null ( @SANCTIONS )

        #Takes a ordered list of payments from the enterprise.
        @PAYMENT_POSITION = enterprise_payment_position( @ENTERPRISE )
        assert_object_is_not_null ( @PAYMENT_POSITION )

        #Takes the position of  an enterprise in a ordered list.
        @POSITION = Enterprise.enterprise_position( @ENTERPRISE )
        assert_object_is_not_null ( @POSITION )
    end

    private

    # Description: Shows the search results in groups of 10 per page.
    # Parameters: search.
    # Return: paginated_result.
    def paginate_results( search )
        enterprises_per_page = 10
        pages = {:page => params[:page], :per_page => enterprises_per_page}
        paginated_result = search.result.paginate( pages )
        assert_object_is_not_null( paginated_result )

        return paginated_result
    end

    # Description: Performs a search with the query provided by the user. If no
    # query is provided, returns all enterprises.
    # Parameters: none.
    # Return: search.
    def search_for_query
        # CNPJ is National Register of Legal Entities.
        search = Enterprise.search( params[:query].try( :merge, m: 'or' ) )
        assert_object_is_not_null ( search )

        return search
    end

    # Description: Recovers the position of a specific enterprise.
    # Parameters: enterprise.
    # Return: recovered_position.
    def enterprise_payment_position( enterprise )
        recovered_position = -1

        enterprises_ordered_by_payments = Enterprise.featured_payments
        enterprises_ordered_by_payments.each_with_index do |organization, index|

            # Returns the position of the Enterprise, based on its payment sum
            iterator_position = 1
            if organization.payments_sum == enterprise.payments_sum
                recovered_position = index + iterator_position
            else
                # Nothing to do.
            end
        end

        return recovered_position
    end
end
