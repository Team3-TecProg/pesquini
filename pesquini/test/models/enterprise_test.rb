######################################################################
# Class name: EnterpriseTest
# File name: enterprise_test.rb
# Description: Class that contains all unit tests for enterprise model
######################################################################

require 'test_helper'

class EnterpriseTest < ActiveSupport::TestCase

    def setup
        @enterprise = Enterprise.new
        @enterprise.save!
    end

    # test "get the last valid sanction" do
    #     @sanction = Sanction.new
    #     @sanction.process_number = 21
    #     @sanction.save!

    #     @enterprise = Enterprise.new
    #     @enterprise.cnpj = 12
    #     @enterprise.save!

    #     @enterprise.sanctions << @sanction

    #     expected_last_sanction = @sanction
    #     returned_last_sanction = @enterprise.last_sanction

    #     assert_equal expected_last_sanction,returned_last_sanction
    # end

end
