######################################################################
# Class name: StateTest
# File name: state_test.rb
# Description: Class that contains all unit tests for state model
######################################################################

require 'test_helper'

class StateTest < ActiveSupport::TestCase

    def setup
        @state = State.new
        @state.save!
    end

    test "get an array with all states" do
        expected_array = [ "BA", "DF", "RJ", "PA", "MG", "SP", "AM",
        "RS", "SC", "ES", "PR", "PB", "RN", "CE", "AL", "RR", "SE",
        "RO","PI" , "AC", "TO", "GO", "PE", "AP", "MS", "MT", "MA",
        "Não Informado" ]
        returned_array = State.get_all_states

        assert_equal expected_array,returned_array
    end

    test "refresh object to ensure that its last version was saved on data base" do
        @state.name = "Distrito Federal"
        @state.save!
        @state.refresh!
        expected_name = "Distrito Federal"
        last_state = State.last

        assert_equal expected_name, last_state.name
    end

end
