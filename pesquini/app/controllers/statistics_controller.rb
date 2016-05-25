######################################################################
# Class name: StatiticsController.
# File name: statistics_controller.rb.
# Description: Controller that contains methods to ranking manipulation.
######################################################################

class StatisticsController < ApplicationController
    include ApplicationHelper
    
    #A list that stores all states.
    @@STATES_LIST = State.get_all_states
    #A list that stores the sanctions of all years.
    @@sanjana = Sanction.get_all_years
    #A list that stores all the types of sanctions.
    @@SANCTION_LIST_TYPE = SanctionType.get_all_sanction_types

    # Description: Method to call the Statistics 'Index' view.
    # Parameters: none.
    # Return: none.
    def  index
    end

    # Description: This method returns an array with the ranking of sanctioned
    # enterprises.
    # Parameters: none.
    # Return: none.
    def most_sanctioned_ranking
        # Array thats contains objects of the most sanctioned enterprises.
        enterprise_group_array = Enterprise.most_sanctioned_ranking

        # Sends the first element to a global variable.
        @ENTERPRISE_GROUP = enterprise_group_array[0]
        assert_object_is_not_null(@ENTERPRISE_GROUP)

        # Sends the second element to a global variable.
        @ENTERPRISE_GROUP_COUNT = enterprise_group_array[1]
        assert_object_is_not_null(@ENTERPRISE_GROUP)
    end

    # Description: This method returns the 10 most sanctioned enterprises.
    # Parameters: none.
    # Return: @ENTERPRISES.
    def most_payed_ranking
        have_sanctions_in_year = false
        if ( params[:sanjana] )
            have_sanctions_in_year = true
            page_params = {:page => params[:page], :per_page => 20}
            @ENTERPRISES = Enterprise.featured_payments.paginate( page_params )
        else
            @ENTERPRISES = Enterprise.featured_payments( 10 )
        end
        assert_object_is_not_null( @ENTERPRISES )

        return @ENTERPRISES
    end

    # Description: This method returns the 10 most sanctioned enterprises per 
    # page.
    # Parameters: none.
    # Return: @ENTERPRISES.
    def enterprise_group_ranking
        @QUANTITY = params[:sanctions_count]
        page_param = {:page => params[:page], :per_page => 10}
        sanction_param = {sanctions_count: @QUANTITY}
        @ENTERPRISES = Enterprise.where( sanction_param ).paginate( page_param )
        assert_object_is_not_null( @ENTERPRISES )
       
        return @ENTERPRISES
    end

    # Description: This method returns the 10 most payed enterprises per page.
    # Parameters: none.
    # Return: @ENTERPRISES.
    def payment_group_ranking
        @QUANTITY = params[:payments_count]
        page_param = {:page =>params[:page], :per_page => 10}
        payment_param = {payments_count: @QUANTITY}
        @ENTERPRISES = Enterprise.where( payment_param ).paginate( page_param )
        assert_object_is_not_null( @ENTERPRISES )

        return @ENTERPRISES
    end

    # Description: This method prepares the data to be plotted in JSon using
    # the highChart gem, through the instance variable @CHART. The chart shows 
    # the country' states and their respective sanctions.
    # Parameters: none.
    # Return: none.
    def sanction_by_state_graph
        gon.states = @@STATES_LIST
        gon.dados = total_by_state

        @CHART = LazyHighCharts::HighChart.new('graph') do |graph_function|
        tittle = "Gráfico de Sanções por Estado"
        graph_function.title(:text => tittle)

        if(params[:year_].to_i != 0)
            graph_function.title(:text => params[:year_].to_i )
        end

        graph_function.xAxis(:categories => @@STATES_LIST)
        header = "Número de Sansções"
        series_param = {:name => header, :yAxis => 0, :data => total_by_state}
        graph_function.series( series_param )
        yAxis_title = {:text => "Sanções", :margin => 30}
        graph_function.yAxis[{:title => yAxis_title },]
        graph_alignment = {:align => 'right', :verticalAlign => 'top', :y => 75,
                            :x => -50, :layout => 'vertical',}
        graph_function.legend(graph_alignment)
        graph_function.chart({:defaultSeriesType=>"column"})
        end
    end

    # Description: This method prepares the data to be plotted in JSon using
    # the highChart gem, through the instance variable @CHART. The chart shows 
    # the country' states and their respective sanction kinds.
    # Parameters: none.
    # Return: none.
    def sanction_by_type_graph
        @CHART = LazyHighCharts::HighChart.new('pie') do |graph_function|
            graph_function.chart( {
                :defaultSeriesType=>"pie" , 
                :margin=> [50, 10, 10, 10]
                } )
            graph_function.series({
                :type=> 'pie',
                :name=> 'Sanções Encontradas',
                :data => total_by_type
            })
            tittle = "Gráfico Sanções por Tipo"
            graph_function.options[:title][:text] = tittle
            graph_function.legend(
                :layout=> 'vertical',
                :style=> {:left=> 'auto',
                          :bottom=> 'auto',
                          :right=> '50px',
                          :top=> '100px'
                         } )
            font = "12px Trebuchet MS, "+ "Verdana, sans-serif" 
            graph_function.plot_options(
                :pie=>{:allowPointSelect=>true,
                :cursor=>"pointer" ,
                :dataLabels=> { :enabled=>true,
                                :color=>"black",
                                :style=> { :font => font
                                          }
                              } 
                        } )
        end

        if (!@STATES)
            @STATES = @@STATES_LIST.clone
            @STATES.unshift( "Todos" )
        end

        respond_to do |format|
            format.html # show.html.erb
            format.js
        end
    end

    # Retrieves an array with the sanctions filtered by a state, in a specific 
    # year.
    # Parameters: none.
    # Return: total_sanction_state.
    def total_by_state
        total_sanction_state = []
        @years = @@sanjana

        @@STATES_LIST.each do |sanction|
            state = State.find_by_abbreviation("#{sanction}")
            sanctions_by_state = Sanction.where(state_id: state[:id])
            selected_year = []
            if( params[:year_].to_i != 0 )
                sanctions_by_state.each do |sanction|
                    if( s.initial_date.year ==  params[:year_].to_i )
                        selected_year << sanction
                    end
                end
                total_sanction_state << ( selected_year.count )
            else
                total_sanction_state << ( sanctions_by_state.count )
            end
        end
        assert_object_is_not_null( total_sanction_state )

        return total_sanction_state
    end

    # Retrieves an array with the sanctions filtered by its type.
    # Parameters: none.
    # Return: total_sanction_state.
    def total_by_type
        # Array of total sanctions made in a state.
        total_sanction_state = []
        # Array of total types of sanctions.
        total_sanction_type = []
        # Iterator beginning in 0. Contains the quantity of sanctions by type.
        count_total_types_of_sanctions = 0

        state = State.find_by_abbreviation( params[:state_] )

        @@SANCTION_LIST_TYPE.each do |selected_sanction|
            sanction = SanctionType.find_by_description(selected_sanction[0])
            sanctions_by_type = Sanction.where( sanction_type:  sanction )
            if ( params[:state_] && params[:state_] != "Todos" )
                sanction_param = {state_id: state[:id] }
                sanctions_by_type = sanctions_by_type.where( sanction_param )
            end
            count_total_types_of_sanctions = count_total_types_of_sanctions
                                             + ( sanctions_by_type.count )
            total_sanction_type  << selected_sanction[1]
            total_sanction_type  << ( sanctions_by_type.count )
            total_sanction_state << total_sanction_type
            total_sanction_type  = []
        end

        total_sanction_type  << "Não Informado"
            if ( params[:state_] && params[:state_] != "Todos" )
                total = Sanction.where( state_id: state[:id] ).count
            else
                total = Sanction.count
            end

        total_sanction_type  << ( total - count_total_types_of_sanctions )
        total_sanction_state << total_sanction_type
        total_sanction_state = 
                        total_sanction_state.sort_by{ |iterator| iterator[0] }
        assert_object_is_not_null( total_sanction_state )

        return total_sanction_state
    end

end
