class EnterprisesController < ApplicationController
  
  def index

    if params[:q].nil?
      @search = Enterprise.search(params[:q].try(:merge, m: 'or'))
      @enterprises = Enterprise.paginate(:page => params[:page], :per_page => 10)
    else
      params[:q][:cnpj_eq] = params[:q][:corporate_name_cont]
      @search = Enterprise.search(params[:q].try(:merge, m: 'or'))
      @enterprises = @search.result.paginate(:page => params[:page], :per_page => 10)
    end
  end

  def show

    @results_per_page = 10

    if (params[:page].to_i > 0)
      @page_number = params[:page].to_i - 1
    else
      @page_number = 0
    end

    @enterprise = Enterprise.find(params[:id])
    @collection = Sanction.where(enterprise_id: @enterprise.id)
    @payments = Payment.where(enterprise_id: @enterprise.id).paginate(:page => params[:page], :per_page => @results_per_page )
    @sanctions = @collection.paginate(:page => params[:page], :per_page => @results_per_page)
    @payment_position = enterprise_payment_position(@enterprise)
    @position = Enterprise.enterprise_position(@enterprise)
  end

  def enterprise_payment_position(enterprise)

    payment_list = Enterprise.featured_payments  
    payment_list.each_with_index do |organization, index|
      if organization.payments_sum == enterprise.payments_sum
        return index + 1
      else
        # Nothing to do. 
      end
    end
  end
end
