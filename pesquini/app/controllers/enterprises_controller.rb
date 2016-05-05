######################################################################
# Class name: EnterprisesController
# File name: enterprises_controller.rb
# Description: Controller for the Enterprises model, which holds --
# -- methods to link it to the Enterprise views.
######################################################################

class EnterprisesController < ApplicationController
  
  def index

    # Lists all the enterprises in the database, if the user did not provide --
    # -- a query to search, or lists the enterprise that matches the --
    # -- provided query otherwise.

    if params[:q].nil?
      @search = Enterprise.search(params[:q].try(:merge, m: 'or'))
      @enterprises = Enterprise.paginate(:page => params[:page], 
                                          :per_page => 10)
    else
      params[:q][:cnpj_eq] = params[:q][:corporate_name_cont]
      @search = Enterprise.search(params[:q].try(:merge, m: 'or'))
      @enterprises = @search.result.paginate(:page => params[:page], 
                                              :per_page => 10)
    end
  end

  def show

    @results_per_page = 10

    # Matches a given Enterprise to its position in the page index. 

    if (params[:page].to_i > 0)
      @page_number = params[:page].to_i - 1
    else
      @page_number = 0
    end

    # Instance variables to be used in the Enterprise Show view.

    @enterprise = Enterprise.find(params[:id])
    @collection = Sanction.where(enterprise_id: @enterprise.id)
    @payments = Payment.where(enterprise_id: @enterprise.id).paginate(:page => 
                                params[:page], :per_page => @results_per_page )
    @sanctions = @collection.paginate(:page => params[:page], 
                                                :per_page => @results_per_page)
    @payment_position = enterprise_payment_position(@enterprise)
    @position = Enterprise.enterprise_position(@enterprise)
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
