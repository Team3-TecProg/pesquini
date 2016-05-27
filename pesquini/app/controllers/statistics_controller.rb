######################################################################
# Class name: StatiticsController.
# File name: statistics_controller.rb.
# Description: Controller that contains methods to ranking manipulation.
######################################################################

class StatisticsController < ApplicationController
    include Assertions

    # Description: Method to call the Statistics 'Index' view.
    # Parameters: none.
    # Return: none.
    def  index
    end

    # Description: This method obtains a list of all the country' states.
    # Parameters: none.
    # Return: states_list.
    def all_states
        states_list = State.get_all_states
        assert_object_is_not_null( states_list )
        return states_list
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
        @CHART = LazyHighCharts::HighChart.new('graph') do |graph_function|
            tittle = "Gráfico de Sanções por Estado"
            graph_function.title(:text => tittle)

            if(params[:year_].to_i != 0)
                graph_function.title(:text => params[:year_].to_i )
            end

            graph_function.xAxis(:categories => all_states)
            header = "Número de Sansções"
            series_param = {:name => header,:yAxis => 0,:data => total_by_state}
            graph_function.series( series_param )
            yAxis_title = {:text => "Sanções", :margin => 30}
            graph_function.yAxis[{:title => yAxis_title },]
            graph_alignment = {:align => 'right', :verticalAlign => 'top', 
            :y => 75, :x => -50, :layout => 'vertical',}
            graph_function.legend(graph_alignment)
            graph_function.chart({:defaultSeriesType=>"column"})
        end
    end

    # Description: This method prepares the data to be plotted in JSon using
    # the highChart gem, through the instance variable @CHART. The chart shows 
    # the country' states and their respective sanction kinds.
    # Parameters: none.
    # Return: format_sanction_by_type_graph.
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
        return format_sanction_by_type_graph
    end

    # Description: prepares the sanction by type graph to HTML and JSon format.
    # Parameters: none
    # Return: none.
    def format_sanction_by_type_graph
        if (!@STATES)
            @STATES = all_states.clone
            @STATES.unshift( "Todos" )
        else 
            # Nothing to do.
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
        @years = Sanction.get_all_years

        all_states.each do |sanction|
            group_sanction_by_state( sanction, total_sanction_state )
        end
        assert_object_is_not_null( total_sanction_state )
        return total_sanction_state
    end

    # Description: Group sanctions by their states, in order to group them by 
    # year.
    # Parameters: sanction, total_sanction_state
    # Return: total_sanction_state
    def group_sanction_by_state ( sanction, total_sanction_state )
        state = State.find_by_abbreviation( "#{sanction}" )
        sanctions_by_state = Sanction.where( state_id: state[:id] )
        selected_year = []
        if( params[:year_].to_i != 0 )
            sanctions_by_state.each do |sanction|
                group_sanction_by_year( sanction, selected_year )
            end
            total_sanction_state << ( selected_year.count )
            return total_sanction_state
        else
            total_sanction_state << ( sanctions_by_state.count )
            return total_sanction_state
        end
    end

    # Description: Verifies if the sanction belongs to a given year, grouping it
    # in an array.
    # Parameters: sanction, selected_year.
    # Return: selected_year.
    def group_sanction_by_year ( sanction, selected_year )
        if( sanction.initial_date.year ==  params[:year_].to_i )
            selected_year << sanction
            return selected_year
        else 
            # Nothing to do.
        end
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
        assert_object_is_not_null( state )
        all_sanctions = SanctionType.get_all_sanction_types
        assert_object_is_not_null( all_sanctions )

        ( all_sanctions ).each do |selected_sanction|
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
