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
        expected_array = [ "BA", "DF", "RJ", "PA", "MG", "SP", "AM", "RS", "SC",
        "ES", "PR", "PB", "RN", "CE", "AL", "RR", "SE", "RO","PI" , "AC",
        "TO", "GO", "PE", "AP", "MS", "MT", "MA", "Não Informado" ]
        returned_array = State.all_states

        assert_equal expected_array,returned_array
    end

end
