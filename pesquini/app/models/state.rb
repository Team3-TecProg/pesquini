######################################################################
# Class name: State
# File name: state.rb
# Description: Represents states in the Brazilian territory
######################################################################

class State < ActiveRecord::Base
    include Assertions

    has_many :sanctions
    validates_uniqueness_of :abbreviation

    # Description: Refreshes a given state.
    # Parameters: none.
    # Return: actual_sanction.
    def update_state
        actual_sanction = State.find_by_abbreviation( self.abbreviation )
        assert_object_is_not_null( actual_sanction )
        return actual_sanction
    end

    # Description: Prepares all state's abbreviations. 
    # Parameters: none.
    # Return: states.
    def self.get_all_states
        states = [ "BA", "DF", "RJ", "PA", "MG", "SP", "AM", "RS", "SC",
        "ES", "PR", "PB", "RN", "CE", "AL", "RR", "SE", "RO","PI" , "AC",
        "TO", "GO", "PE", "AP", "MS", "MT", "MA", "Não Informado" ]

        return states
    end

end
