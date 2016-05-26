######################################################################
# File name: state_spec.rb.
# Description: This file contains all units tests for state
# model.
######################################################################

require 'spec_helper'
require 'rails_helper'

describe State do
    before do
        @state = State.new
        @state.abbreviation = "DF1"
        @state.save
    end

    subject {@state}
        it { should respond_to(:abbreviation) }
        it { should respond_to(:id) }
        it { should respond_to(:code) }
        it { should respond_to(:name) }
    it { should be_valid }

    describe "uniqueness validation of abbreviation" do

    describe "unique abbreviation" do
        it "should be_valid" do
            uniqueness_state = State.new
            uniqueness_state.abbreviation = "SP1"
            uniqueness_state.save
            expect(uniqueness_state).to be_valid
        end
    end

    describe "duplicated abbreviation" do
        it "should not be_valid" do
            duplicated_state = State.new
            duplicated_state.abbreviation = "DF1"
            expect(duplicated_state).not_to be_valid
        end
    end


    describe "#update" do
        before do
            @new_state = State.new
            @new_state.abbreviation = "Es_Teste"
            @new_state.save
        end

        it "should return state" do
            expect(@new_state.update_state).to eq(@new_state);
        end

        it "should not return other state" do
            expect(@new_state.update_state).not_to eq(@state);
        end
    end

    describe "#get_all_states" do
        expected_returned_array_of_states = [ "BA", "DF", "RJ", "PA", "MG", "SP",
        "AM", "RS", "SC","ES", "PR", "PB", "RN", "CE", "AL", "RR", "SE",
        "RO","PI" , "AC","TO", "GO", "PE", "AP", "MS", "MT", "MA",
        "Não Informado" ]

        it "should return an array with all states" do
            expect(State.get_all_states).to eq(expected_returned_array_of_states)
        end
    end
  end
end
