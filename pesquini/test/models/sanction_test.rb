######################################################################
# Class name: SanctionTest
# File name: sanction_test.rb
# Description: Class that contains all unit tests for sanction model
######################################################################

require 'test_helper'

class SanctionTest < ActiveSupport::TestCase

    def setup
        @sanction_1 = Sanction.new
        @sanction_1.save!
        # @sanction_2 = Sanction.new
        # @sanction_2.save!
    end

    test "get all the sanctions years" do
        returned_years = Sanction.get_all_years
        expected_years = ["Todos",1988, 1991, 1992, 1995, 1996, 1997, 1998,
         1999, 2000, 2001, 2002,2003, 2004, 2005, 2006, 2007, 2008, 2009,
          2010, 2011, 2012, 2013,2014, 2015]

        assert_equal returned_years,expected_years
    end

    test "get percentual that sanctions value represents on total value of sanctions" do
        test_value = 1
        expected_percentual = 0.01889287738522577
        returned_percentual = Sanction.percentual_sanction(test_value)

        assert_equal expected_percentual,returned_percentual
    end

end
