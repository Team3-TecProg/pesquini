######################################################################
# Class name: StatiticsController.
# File name: statistics_controller.rb.
# Description: Controller that contains methods to ranking
# manipulation.
######################################################################

class StatisticsController < ApplicationController

    #A list that stores all states.
    @@STATES_LIST = State.all_states
    #A list that stores the sanctions of all years.
    @@sanjana = Sanction.get_all_years
    #A list that stores all the types of sanctions.
    @@SANCTION_LIST_TYPE = SanctionType.all_sanction_types

    # Description: Method to call view of statistics.
    # Parameters: none.
    # Return: none.
    def  index
    end

    # Description: This method return a array with the sanctioned ranking of
    # enterprises.
    # Parameters: none.
    # Return: none.
    def most_sanctioned_ranking
        # Array thats contains objects of the moste sanctioned enterprises.
        enterprise_group_array = Enterprise.most_sanctioned_ranking

        # Send the first element to a global variable.
        @ENTERPRISE_GROUP = enterprise_group_array[0]
        # Assert if the object is valid, whithout null value.
        assert_object_is_not_null(@ENTERPRISE_GROUP)

        # Send the second element to a global variable.
        @ENTERPRISE_GROUP_COUNT = enterprise_group_array[1]
        # Assert if the object is valid, whithout null value.
        assert_object_is_not_null(@ENTERPRISE_GROUP)
    end

    # Description: This method return the 10 most sanction enterprises.
    # Parameters: none.
    # Return: @ENTERPRISES.
    def most_paymented_ranking
        have_sanctions_in_year = false
        if ( params[:sanjana] )
            have_sanctions_in_year = true
            @ENTERPRISES = Enterprise.featured_payments.paginate(:page =>
                                                                 params[:page],
                                                                 :per_page =>
                                                                 20)
        else
            @ENTERPRISES = Enterprise.featured_payments(10)
        end
        assert_object_is_not_null( @ENTERPRISES )

        return @ENTERPRISES
    end

    # Description: This method return the 10 most sanctions
    # enterprises per page.
    # Parameters: none.
    # Return: @ENTERPRISES.
    def enterprise_group_ranking
        @QUANTITY = params[:sanctions_count]
        @ENTERPRISES = Enterprise.where(sanctions_count:
                                        @QUANTITY).paginate(:page =>
                                                              params[:page],
                                                              :per_page => 10)
        assert_object_is_not_null( @ENTERPRISES )

        return @ENTERPRISES
    end

    # Description: This method return the 10 most payeds enterprises per page.
    # Parameters: none.
    # Return: @ENTERPRISES.
    def payment_group_ranking
        @QUANTITY = params[:payments_count]
        @ENTERPRISES = Enterprise.where(payments_count:
                                        @QUANTITY).paginate(:page =>
                                                              params[:page],
                                                              :per_page => 10)
        assert_object_is_not_null( @enterprises )

        return @ENTERPRISES
    end

    # Description: This method prepare the data to be ploted in JS using
    # highChart, the global variable @CHART do this. The chart is about the
    # states where sanctions made in each state.
    # Parameters: none.
    # Return: none.
    def sanction_by_state_graph
        gon.states = @@STATES_LIST
        gon.dados = total_by_state
        tittle = "Gráfico de Sanções por Estado"

        @CHART = LazyHighCharts::HighChart.new('graph') do |graph_function|
        graph_function.title(:text => tittle)

            if(params[:year_].to_i != 0)
                graph_function.title(:text => params[:year_].to_i )
            end

            graph_function.xAxis(:categories => @@STATES_LIST)
            graph_function.series(:name => "Número de Sanções", :yAxis => 0, :data =>
                     total_by_state)
            graph_function.yAxis [
            {:title => {:text => "Sanções", :margin => 30} },
                    ]
            graph_function.legend(:align => 'right', :verticalAlign => 'top', :y => 75,
                     :x => -50, :layout => 'vertical',)
            graph_function.chart({:defaultSeriesType=>"column"})
        end
    end

    # Description: This method prepare the data to be ploted in JS using
    # highChart, the global variable @CHART do this. The chart is about the
    # states where the kind of sanctions were made in each state.
    # Parameters: none.
    # Return: none.
    def sanction_by_type_graph
        tittle = "Gráfico Sanções por Tipo"
        @CHART = LazyHighCharts::HighChart.new('pie') do |graph_function|
            graph_function.chart({:defaultSeriesType=>"pie" ,:margin=> [50, 10, 10, 10]} )
            graph_function.series({
                :type=> 'pie',
                :name=> 'Sanções Encontradas',
                :data => total_by_type
            })
            graph_function.options[:title][:text] = tittle
            graph_function.legend(:layout=> 'vertical',:style=> {:left=> 'auto',
                                                    :bottom=> 'auto',
                                                    :right=> '50px',
                                                    :top=> '100px'})
            graph_function.plot_options(:pie=>{:allowPointSelect=>true,
                                  :cursor=>"pointer" ,
                                  :dataLabels=> { :enabled=>true,
                                                  :color=>"black",
                                                  :style=> { :font =>
                                                  "12px Trebuchet MS, "+
                                                  "Verdana, sans-serif" }
                                                }
                                 }
                          )
        end

        if (!@STATES)
            @STATES = @@STATES_LIST.clone
            @STATES.unshift("Todos")
        end

        respond_to do |format|
            format.html # show.html.erb
            format.js
        end
    end

# Move this to helper.
######################################################
# Auxiliary methods

    #Retrieves an array with the sanctions filtered by a state, in a specific year.
    # Parameters: none.
    # Return: results.
    def total_by_state
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
        assert_object_is_not_null( results )

        return results
    end

    #Retrieves an array with the sanctions filtered by its type.
    # Parameters: none.
    # Return: results.
    def total_by_type
        results = []
        results2 = []
        count = 0

        state = State.find_by_abbreviation(params[:state_])

        @@SANCTION_LIST_TYPE.each do |s|
            sanction = SanctionType.find_by_description(s[0])
            sanctions_by_type = Sanction.where(sanction_type:  sanction)
            if (params[:state_] && params[:state_] != "Todos")
                sanctions_by_type = sanctions_by_type.where(state_id: state[:id])
            end
            count = count + (sanctions_by_type.count)
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

        results2 << (total - count)
        results << results2
        results = results.sort_by { |iterator| iterator[0] }
        assert_object_is_not_null( results )

        return results
    end

end
