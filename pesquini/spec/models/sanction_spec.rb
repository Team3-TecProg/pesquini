require 'spec_helper'
require 'rails_helper'

describe Sanction do
    before do
        @sanction = Sanction.new
        @sanction.process_number = "9090"
        @sanction.save
    end

    subject { @sanction }
    it { should respond_to(:process_number) }
    it { should be_valid }

    describe 'percentual_sanction' do
        it " to do work" do
            b = Sanction.percentual_sanction(10000)
            c = b.to_i
            expect(c).to eq(188)
        end
    end

    describe "uniqueness validation of process_number" do

        describe "unique process_number" do
            it "should be_valid" do
                uniqueness_sanction = Sanction.new
                uniqueness_sanction.process_number = "123"
                expect(uniqueness_sanction).to be_valid
            end
        end

        describe "duplicated process_number" do
            it "should not be_valid" do
                duplicated_sanction = Sanction.new
                duplicated_sanction.process_number = "9090"
                expect(duplicated_sanction).not_to be_valid
            end
        end

        describe "#refresh!" do
            before do
                @s = Sanction.new
                @s.process_number = "356754"
                @s.save
            end

            it "should return sanction" do
                expect(@s.refresh!).to eq(@s);
            end

            it "should not return other sanction" do
                expect(@s.refresh!).not_to eq(@sanction);
            end
        end

        describe "#get_all_years" do
            expected_returned_array_of_years = years = ["Todos",1988,
            1991, 1992, 1995, 1996, 1997, 1998, 1999, 2000, 2001, 2002,
            2003, 2004, 2005, 2006, 2007, 2008, 2009, 2010, 2011, 2012,
            2013,2014, 2015]

            it "should return an array with all years" do
                expect(Sanction.get_all_years).to eq(expected_returned_array_of_years)
            end
        end
    end
end
