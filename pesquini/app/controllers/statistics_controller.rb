class StatisticsController < ApplicationController


@@STATES_LIST = State.all_states

@@sanjana = Sanction.all_years

@@SANCTION_LIST_TYPE = SanctionType.all_sanction_types


  def  index
  end

  # This method return a array with the sanctioned ranking of enterprises.
  def most_sanctioned_ranking

    # Array thats contains objects of the moste sanctioned enterprises.
    enterprise_group_array = Enterprise.most_sanctioned_ranking
    @ENTERPRISE_GROUP = enterprise_group_array[0]
    assert_object_is_not_null(@ENTERPRISE_GROUP)
    @ENTERPRISE_GROUP_COUNT = enterprise_group_array[1]
    assert_object_is_not_null(@ENTERPRISE_GROUP)

  end

  def most_paymented_ranking
    have_sanctions_in_year = false
    if params[:sanjana]
      have_sanctions_in_year = true
      @enterprises = Enterprise.featured_payments.paginate(:page => params[:page], :per_page => 20)
    else
      @enterprises = Enterprise.featured_payments(10)
    end
  end

  def enterprise_group_ranking
    @quantidade = params[:sanctions_count]
    @enterprises = Enterprise.where(sanctions_count: @quantidade).paginate(:page => params[:page], :per_page => 10)
  end

  def payment_group_ranking
    @quantidade = params[:payments_count]
    @enterprises = Enterprise.where(payments_count: @quantidade).paginate(:page => params[:page], :per_page => 10)
  end

  def sanction_by_state_graph
    gon.states = @@STATES_LIST
    gon.dados = total_by_state
    titulo = "Gráfico de Sanções por Estado"
    @chart = LazyHighCharts::HighChart.new('graph') do |f|
      f.title(:text => titulo)
      if(params[:year_].to_i != 0)
         f.title(:text => params[:year_].to_i )
       end
      f.xAxis(:categories => @@STATES_LIST)
      f.series(:name => "Número de Sanções", :yAxis => 0, :data => total_by_state)
      f.yAxis [
      {:title => {:text => "Sanções", :margin => 30} },
      ]
      f.legend(:align => 'right', :verticalAlign => 'top', :y => 75, :x => -50, :layout => 'vertical',)
      f.chart({:defaultSeriesType=>"column"})
    end
  end


 def sanction_by_type_graph
    titulo = "Gráfico Sanções por Tipo"
    @chart = LazyHighCharts::HighChart.new('pie') do |f|
        f.chart({:defaultSeriesType=>"pie" ,:margin=> [50, 10, 10, 10]} )
        f.series({
                 :type=> 'pie',
                 :name=> 'Sanções Encontradas',
                 :data => total_by_type
        })
        f.options[:title][:text] = titulo
        f.legend(:layout=> 'vertical',:style=> {:left=> 'auto', :bottom=> 'auto', :right=> '50px', :top=> '100px'})
        f.plot_options(:pie=>{
          :allowPointSelect=>true,
          :cursor=>"pointer" ,
          :dataLabels=>{
            :enabled=>true,
            :color=>"black",
            :style=>{
            :font=>"12px Trebuchet MS, Verdana, sans-serif"
            }
          }
        })
    end

    if (!@states)
      @states = @@STATES_LIST.clone
      @states.unshift("Todos")
    end
    respond_to do |format|
      format.html # show.html.erb
      format.js
    end

  end

# Move this to helper.
######################################################
# Auxiliary methods 

  def total_by_state()
    results = []
    @years = @@sanjana
    @@STATES_LIST.each do |s|
      state = State.find_by_abbreviation("#{s}")
      sanctions_by_state = Sanction.where(state_id: state[:id])
      selected_year = []
      if(params[:year_].to_i != 0)
        sanctions_by_state.each do |s|
          if(s.initial_date.year ==  params[:year_].to_i)
            selected_year << s
          end
      end
        results << (selected_year.count)
      else
        results << (sanctions_by_state.count)
      end
    end
    results
  end


  def total_by_type()
    results = []
    results2 = []
    cont = 0

    state = State.find_by_abbreviation(params[:state_])

    @@SANCTION_LIST_TYPE.each do |s|
      sanction = SanctionType.find_by_description(s[0])
      sanctions_by_type = Sanction.where(sanction_type:  sanction)
      if (params[:state_] && params[:state_] != "Todos")
        sanctions_by_type = sanctions_by_type.where(state_id: state[:id])
      end
      cont = cont + (sanctions_by_type.count)
      results2 << s[1]
      results2 << (sanctions_by_type.count)
      results << results2
      results2 = []
    end
    results2 << "Não Informado"
      if (params[:state_] && params[:state_] != "Todos")
        total =Sanction.where(state_id: state[:id] ).count
      else
        total = Sanction.count
      end
    results2 << (total - cont)
    results << results2
    results = results.sort_by { |i| i[0] }
    results
  end
end
